#!/bin/bash
#
# A black box whose pin names do not match has failed to match.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}
TIMELIMIT=60 run_netgen ${TESTDIR}/lvs.tcl > lvs.log
code=$?

if [ ${code} -eq 0 ]; then
    echo "  ok:  netgen finished"
else
    echo "  FAIL:  netgen did not finish normally (exit status ${code})"
    status=1
fi
expect_line comp.out "^Cell pin lists for blk and blk altered to match" \
	"pins of blk are reported as not matching"
expect_line comp.out "^Subcell\(s\) failed matching" \
	"final result reports a subcell that failed to match"
expect_line comp.out "^ blk\(0\)$" \
	"blk is listed as failing to match"
expect_no_line comp.out "^Final result: Circuits match" \
	"the netlists are not reported as matching"

finish ${status}
