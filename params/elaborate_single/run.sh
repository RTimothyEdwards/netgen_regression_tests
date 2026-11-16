#!/bin/bash
#
# A subcircuit given one set of parameters is resolved in place.  See README.md.

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
expect_line comp.out "^Circuit 1: cell +\|Circuit 2: cell " \
	"cell is compared hierarchically"
expect_no_line comp.out "@[0-9]" \
	"no copies of cell are made"

finish ${status}
