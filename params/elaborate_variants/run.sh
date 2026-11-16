#!/bin/bash
#
# A subcircuit given several sets of parameters is copied for each set.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_line comp.out "^Final result: Circuits match uniquely" \
	"netlists match"
expect_no_line comp.out "[Pp]roperty errors" \
	"no property errors"
expect_no_line comp.out "unresolved" \
	"no unresolved parameter expressions"
expect_line comp.out "^Subcircuits instanced with more than one set of parameters" \
	"copies are listed"
expect_line comp.out "^  Circuit \([0-9]+\): cell@1:  W=2$" \
	"cell@1 has W=2 (the first instance's set)"
expect_line comp.out "^  Circuit \([0-9]+\): cell@2:  W=3$" \
	"cell@2 has W=3"
expect_no_line comp.out "^Circuit 1: cell +\|Circuit 2: cell " \
	"the unused original cell is not compared"

finish ${status}
