#!/bin/bash
#
# A pin-only mismatch in the top cell is reported as a pin mismatch.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.329

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

final_result comp.out > final.txt
expect_line final.txt "^Final result: Top level cell failed pin matching" \
	"final result reports the pin mismatch"
expect_no_line final.txt "Netlists do not match" \
	"final result does not report a net mismatch"

finish ${status}
