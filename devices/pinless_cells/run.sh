#!/bin/bash
#
# Cells with no pins are merged and compared.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.331

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_line comp.out "^Final result: Circuits match uniquely" \
	"netlists with merged cells that have no pins match"

finish ${status}
