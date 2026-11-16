#!/bin/bash
#
# Cells with contents in only one netlist are listed in the summary.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.329

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

# The summary, between its heading and the "Final result" line.
sed -n '/^The following subcircuits were treated as black boxes/,/^Final result:/p' \
	comp.out > summary.txt

expect_line summary.txt "^The following subcircuits were treated as black boxes" \
	"summary is printed"
expect_line summary.txt "^Final result:" \
	"summary comes before the final result"
expect_line summary.txt "^  Circuit \([0-9]+\): blk2$" \
	"blk2 is listed (contents only in the layout)"
expect_line summary.txt "^  Circuit \([0-9]+\): blk1$" \
	"blk1 is listed (contents only in the schematic)"
expect_no_line summary.txt "blk3" \
	"blk3 is not listed (empty in both)"
expect_line comp.out "^Final result: Circuits match uniquely" \
	"netlists match"

finish ${status}
