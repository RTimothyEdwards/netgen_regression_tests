#!/bin/bash
#
# Parameters passed through more than one level of hierarchy.  See README.md.

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
expect_count comp.out "^  Circuit \([0-9]+\): mid@[0-9]+:" 2 \
	"two copies of mid"
expect_count comp.out "^  Circuit \([0-9]+\): inner@[0-9]+:" 4 \
	"four copies of inner"

finish ${status}
