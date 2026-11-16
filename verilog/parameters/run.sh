#!/bin/bash
#
# Verilog parameters passed through the hierarchy.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}

for v in header body; do
    run_netgen ${TESTDIR}/${v}.tcl > ${v}.log
    expect_line ${v}.out "^Final result: Circuits match uniquely" \
	    "${v}.v:  netlists match"
    expect_no_line ${v}.out "[Pp]roperty errors" \
	    "${v}.v:  no property errors"
    expect_no_line ${v}.log "does not define a default|Expecting" \
	    "${v}.v:  parameters are read without errors"
done

run_netgen ${TESTDIR}/positional.tcl > positional.log
expect_line positional.log "given by position is not supported" \
	"positional.v:  a value given by position is reported"

finish ${status}
