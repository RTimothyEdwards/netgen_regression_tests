#!/bin/bash
#
# Unresolved expressions are reported as such.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_line comp.out "^ value \(unresolved expressions\.\)" \
	"voltage source values are reported as unresolved"
expect_line comp.out "^ W \(unresolved expressions\.\)" \
	"transistor widths are reported as unresolved"
expect_no_line comp.out "circuit1: [-0-9.]+e-3[0-9][0-9] " \
	"no garbage numbers"

finish ${status}
