#!/bin/bash
#
# Instances made by generate "for" loops.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.333

cd ${WORK}
run_netgen ${TESTDIR}/lvs.tcl > lvs.log

expect_no_line lvs.log "not a number or a parameter|placeholder" \
	"the loops are read, including the block label"
expect_count lvs.log "^Device '[uv]\[[0-9]\]' Pins:" 5 \
	"each instance is named with its loop index"
expect_line comp.out "^Final result: Circuits match uniquely" \
	"netlists match"

finish ${status}
