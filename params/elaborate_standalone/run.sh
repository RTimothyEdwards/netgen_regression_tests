#!/bin/bash
#
# A parameterized subcircuit compared on its own uses its defaults.  See README.md.

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

finish ${status}
