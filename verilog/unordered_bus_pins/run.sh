#!/bin/bash
#
# A bus connected to a SPICE cell whose bus pins are not listed in order.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.329

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_no_line lvs.log "Implicit pin" \
	"no instance pins are left unconnected"
expect_line comp.out "^Final result: Circuits match uniquely" \
	"netlists match"

finish ${status}
