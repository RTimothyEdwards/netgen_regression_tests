#!/bin/bash
#
# Writing a netlist with "writenet spice".  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.333

cd ${WORK}
run_netgen ${TESTDIR}/write.tcl > write.log

expect_line write.log "^WRITTEN" \
	"netgen writes the file without crashing"
expect_line top.spice "^\.SUBCKT inv a y vdd vss$" \
	"subcircuit is written with its pin names"
expect_line top.spice "^\.SUBCKT top in out vdd vss$" \
	"top cell is written as a subcircuit with its pin names"
expect_line top.spice "^M\S+ y a vdd vdd pfet( |$)" \
	"transistor is written with the nets of all of its pins"
expect_count top.spice "^X\S+ (in mid|mid out) vdd vss inv$" 2 \
	"both subcircuit instances are written with their nets"
expect_line top.spice "^R\S+ out n1 1000$" \
	"resistor is written with its value"
expect_line top.spice "^C\S+ n1 vss 1e-14$" \
	"capacitor is written with its value"
expect_line top.spice "^R\S+ n1 n2 rpoly .*w=1e-06" \
	"resistor with a model is written with the model and properties"
expect_line write.log "^READ BACK" \
	"the file is read back"
expect_no_line write.log "Fatal|inside of itself" \
	"the file is read back without errors"
expect_line comp.out "^Final result: Circuits match uniquely" \
	"the file read back matches the original"

finish ${status}
