#!/bin/bash
# Reusing a Tcl option object must not reuse another command's index.

TESTDIR=$(cd "$(dirname "$0")" && pwd)
source "${TESTDIR}/../../common/common.sh"
require_netgen_version 1.5.332

# Add require_netgen_version with the actual first fixed release before
# merging this companion test.  See README.md.

for OPTION_CASE in literal_spice shared_spice abbreviated_spice \
        shared_verilog abbreviated_verilog readlib_spice write_then_read \
        invalid_read_format ambiguous_write_format invalid_summary \
        invalid_run invalid_boolean; do
    export OPTION_CASE
    mkdir -p "${WORK}/${OPTION_CASE}"
    cd "${WORK}/${OPTION_CASE}"
    cp "${TESTDIR}/input.spice" "${TESTDIR}/input.v" .
    if ! run_netgen "${TESTDIR}/check.tcl" > run.log; then
        echo "  FAIL: netgen failed for ${OPTION_CASE}"
        status=1
    fi
    expect_line run.log '^OPTION CHECK PASSED$' \
        "${OPTION_CASE}: the option belongs to the current command"
    expect_no_line run.log 'CHECK FAILED|AddressSanitizer|Fatal:' \
        "${OPTION_CASE}: no runtime or assertion error"
done

finish ${status}
