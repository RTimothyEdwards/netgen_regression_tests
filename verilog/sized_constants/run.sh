#!/bin/bash
#
# Verilog parameter values given as based constants.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.331

cd ${WORK}
run_netgen ${TESTDIR}/sized.tcl > sized.log

expect_line sized.out "^Final result: Circuits match uniquely" \
	"netlists match"
expect_no_line sized.out "[Pp]roperty errors" \
	"no property errors"
expect_no_line sized.log "not a number|cannot be parsed|Bad expression" \
	"values are read without errors"

finish ${status}
