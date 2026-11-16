#!/bin/bash
#
# A net mismatch in the top cell is reported as such in the final result.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.329

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

final_result comp.out > final.txt
expect_line final.txt "^Final result: Netlists do not match" \
	"final result reports the net mismatch"
expect_no_line final.txt "failed pin matching" \
	"final result does not report a pin mismatch"
expect_no_line comp.out "^Device classes top and top are equivalent" \
	"top cells are not reported as equivalent"

finish ${status}
