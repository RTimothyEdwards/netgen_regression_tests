#!/bin/bash
#
# "flatten class" applies to copies made by elaboration.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_no_line lvs.log "FLATTEN ERROR" \
	"flatten class finds the instances of the copies"
expect_no_line comp.out "Flattening unmatched subcell cell@" \
	"copies were already flattened before the comparison"
expect_line comp.out "^Final result: Circuits match uniquely" \
	"netlists match"

finish ${status}
