#!/bin/bash
#
# A verilog module that netgen cannot read.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.331

cd ${WORK}
run_netgen ${TESTDIR}/read.tcl > read.log

expect_line read.log "Module 'gen' cannot be read by netgen" \
	"the module that cannot be read is reported"
expect_line read.log "^cells: .*\\<after\\>" \
	"the module after it in the file is read"
expect_line read.log "^cells: .*\\<gen\\>" \
	"the module is defined under its own name"
expect_no_line read.log "^cells: .*_PLACEHOLDER_" \
	"no cell is left named _PLACEHOLDER_"

finish ${status}
