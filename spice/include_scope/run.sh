#!/bin/bash
#
# Files read with .include are part of the including file.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}

run_netgen ${TESTDIR}/subckt.tcl > subckt.log
expect_line subckt.out "^Final result: Circuits match uniquely" \
	"include inside a subcircuit:  netlists match"
expect_no_line subckt.out "[Pp]roperty errors" \
	"include inside a subcircuit:  local parameter is used"

run_netgen ${TESTDIR}/top.tcl > top.log
expect_no_line top.log "exists already" \
	"include at top level:  top-level cell is not started over"
expect_line top.out "^Final result: Circuits match uniquely" \
	"include at top level:  netlists match"

finish ${status}
