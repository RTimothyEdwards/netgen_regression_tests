#!/bin/bash
#
# Instance names of voltage and current sources read from SPICE.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_line comp.out "^vsrc:b vs\. vsrc:b:" \
	"the property error names the voltage source Vb"
expect_count comp.out "^ value circuit1: " 1 \
	"only Vb has a property error"
expect_no_line comp.out "e-3[0-9][0-9] " \
	"no garbage property values"

finish ${status}
