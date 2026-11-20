#!/bin/bash
# Derived area/perimeter values must survive repeated calls and stay local
# to each instance.  See README.md.

TESTDIR=$(cd "$(dirname "$0")" && pwd)
source "${TESTDIR}/../../common/common.sh"

# Before this draft is merged, add require_netgen_version with the first
# released version containing the source fix for netgen issue #113.

for DERIVE_CASE in match area_mismatch perimeter_mismatch swapped; do
    for DERIVE_NAME in a ab abc x cap_mim.ext; do
        export DERIVE_CASE DERIVE_NAME
        mkdir -p "${WORK}/${DERIVE_CASE}_${DERIVE_NAME}"
        cd "${WORK}/${DERIVE_CASE}_${DERIVE_NAME}"
        if ! run_netgen "${TESTDIR}/lvs.tcl" > lvs.log; then
            echo "  FAIL: netgen failed for ${DERIVE_CASE}/${DERIVE_NAME}"
            status=1
        fi
        expect_line comp.out '^Final result: Circuits match uniquely' \
            "${DERIVE_CASE}/${DERIVE_NAME}: topology matches"
        expect_no_line lvs.log 'Fatal:|Segmentation fault|AddressSanitizer' \
            "${DERIVE_CASE}/${DERIVE_NAME}: no runtime error"
        case ${DERIVE_CASE} in
            match|swapped)
                expect_no_line comp.out '[Pp]roperty errors|no matching property' \
                    "${DERIVE_CASE}/${DERIVE_NAME}: equal area and perimeter match"
                ;;
            area_mismatch)
                expect_line comp.out '^ area circuit1:' \
                    "${DERIVE_CASE}/${DERIVE_NAME}: area mismatch reported"
                expect_line comp.out '^ perimeter circuit1:' \
                    "${DERIVE_CASE}/${DERIVE_NAME}: perimeter mismatch reported"
                expect_line comp.out '^Property errors were found' \
                    "${DERIVE_CASE}/${DERIVE_NAME}: final property failure"
                ;;
            perimeter_mismatch)
                expect_no_line comp.out '^ area circuit1:' \
                    "${DERIVE_CASE}/${DERIVE_NAME}: areas agree"
                expect_line comp.out '^ perimeter circuit1:' \
                    "${DERIVE_CASE}/${DERIVE_NAME}: unequal perimeters rejected"
                expect_line comp.out '^Property errors were found' \
                    "${DERIVE_CASE}/${DERIVE_NAME}: final property failure"
                ;;
        esac
    done
done

for DERIVE_ORDER in area_first perimeter_first; do
    export DERIVE_ORDER
    mkdir -p "${WORK}/${DERIVE_ORDER}"
    cd "${WORK}/${DERIVE_ORDER}"
    if ! run_netgen "${TESTDIR}/properties.tcl" > properties.log; then
        echo "  FAIL: netgen failed for ${DERIVE_ORDER}"
        status=1
    fi
    expect_line properties.log '^PROPERTY CHECKS PASSED$' \
        "${DERIVE_ORDER}: values preserved, missing inputs not inherited, all cells visited"
    expect_no_line properties.log 'Fatal:|Segmentation fault|AddressSanitizer|CHECK FAILED' \
        "${DERIVE_ORDER}: no runtime or assertion error"
done

finish ${status}
