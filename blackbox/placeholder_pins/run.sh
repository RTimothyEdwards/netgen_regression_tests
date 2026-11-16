#!/bin/bash
#
# Pins of placeholder (undefined) devices are compared.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_no_line comp.out "no current cell" \
	"pins of the black boxes are compared"
expect_line comp.out "^Cell pin lists are equivalent" \
	"pin lists of the black boxes are equivalent"
expect_line comp.out "^Final result: Circuits match uniquely" \
	"netlists match"

finish ${status}
