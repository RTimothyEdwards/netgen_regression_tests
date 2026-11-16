#!/bin/bash
#
# A verilog instance of a cell read from CDL, using escaped names and a bus.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.328

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_no_line lvs.log "which is not in the" \
	"all instance pins are found in the CDL cell"
expect_no_line lvs.log "Implicit pin" \
	"no instance pins are left unconnected"
expect_line comp.out "^Final result: Circuits match uniquely" \
	"netlists match"

finish ${status}
