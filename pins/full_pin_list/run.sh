#!/bin/bash
#
# The pin list of a cell that fails to match is printed in full.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.329

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

# The pin list:  from the line after the header divider to the closing
# divider line.
sed -n '/^Subcircuit pins:/,$p' comp.out | sed -n '4,$p' |
	sed '/^-----/,$d' > pins.txt
sed -n '/^Subcircuit pins:/,$p' comp.out | sed -n '4,$p' |
	grep -m1 -B1 "^Cell pin lists" > after_pins.txt

expect_line after_pins.txt "^-----" \
	"pin list ends with a divider line"
for p in a b c d e g; do
    expect_line pins.txt "^${p} |\|${p}( |$)" \
	    "pin ${p} is listed"
done
expect_line comp.out "^Cell pin lists for top and top altered to match" \
	"pin lists are reported as altered, not equivalent"

finish ${status}
