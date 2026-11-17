#!/bin/bash
#
# Copies of a module made by yosys for each set of parameters.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.331
require_yosys

cd ${WORK}
run_netgen ${TESTDIR}/layout.tcl > layout.log
run_netgen ${TESTDIR}/layout_bad.tcl > layout_bad.log

expect_line layout.log "Module 'id_prog' cannot be read by netgen" \
	"id_prog is to be elaborated by yosys"
expect_line layout.log "^Module id_prog elaborated by yosys" \
	"id_prog is elaborated by yosys"
expect_line layout.log "id_prog has 3 unique sets of parameters \(copies made by yosys\)" \
	"a copy is made for each value of ID"
expect_line layout.out "^Final result: Circuits match uniquely" \
	"netlists match"
expect_line layout_bad.out "^Final result: Netlists do not match" \
	"netlists with one wrong bit do not match"

finish ${status}
