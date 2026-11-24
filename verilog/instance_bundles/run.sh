#!/bin/bash
#
# Wire bundles connected to instances and instance arrays.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.334

cd ${WORK}
run_netgen ${TESTDIR}/lvs_defined.tcl > defined.log
expect_line defined.log "^LVS Done" \
	"defined cells: netgen ran to the end"
expect_no_line defined.log "Implicit pin|not in the .* cell definition" \
	"defined cells: all instance pins are connected"
expect_line defined.out "^Final result: Circuits match uniquely" \
	"defined cells: netlists match"

run_netgen ${TESTDIR}/lvs_placeholder.tcl > placeholder.log
expect_line placeholder.log "^LVS Done" \
	"placeholder cells: netgen ran to the end"
expect_line placeholder.out "^Final result: Circuits match uniquely" \
	"placeholder cells: netlists match"

finish ${status}
