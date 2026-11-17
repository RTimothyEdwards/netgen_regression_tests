#!/bin/bash
#
# A module elaborated by yosys within a hierarchy.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.331
require_yosys

cd ${WORK}
for v in verilog_top spice_top; do
    run_netgen ${TESTDIR}/${v}.tcl > ${v}.log
    expect_line ${v}.log "^Module mid elaborated by yosys with parameters N=3" \
	    "${v}:  mid is elaborated by yosys with N=3"
    expect_line ${v}.log "child has 3 unique sets of parameters" \
	    "${v}:  values of W from yosys are passed to child"
    expect_line ${v}.out "^Final result: Circuits match uniquely" \
	    "${v}:  netlists match"
    expect_no_line ${v}.out "[Pp]roperty errors" \
	    "${v}:  no property errors"
done
expect_no_line spice_top.log "redefines a verilog module" \
	"spice_top:  no error for a SPICE instance of a verilog module"

finish ${status}
