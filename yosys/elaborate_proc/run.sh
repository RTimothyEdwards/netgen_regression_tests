#!/bin/bash
#
# The netgen::yosys_elaborate procedure.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.331
require_yosys

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

for v in a5 decimal native; do
    expect_line ${v}.out "^Final result: Circuits match uniquely" \
	    "${v}:  elaborated netlist matches the gate-level netlist"
done
# These have the same number of bits high as 8'ha5, so the netlists differ
# only in which pins connect to which cells (pin matching fails).
for v in 5a default; do
    expect_line ${v}.out "^Final result:" \
	    "${v}:  netlists are compared"
    expect_no_line ${v}.out "^Final result: Circuits match" \
	    "${v}:  elaborated netlist (different ID) does not match"
done
expect_line lvs.log "^Cells not defined .*: tieh, tiel, decap" \
	"without stubs, the cells are found to be undefined"
expect_line nostubs.out "^Final result: Circuits match uniquely" \
	"without stubs (pins taken from instances), netlists match"
expect_line lvs.log '^error output: ""$' \
	"on an error, an empty string is returned"
expect_line lvs.log "'no_such_module' is not a valid top-level module" \
	"the yosys error is reported"

finish ${status}
