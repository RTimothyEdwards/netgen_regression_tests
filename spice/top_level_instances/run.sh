#!/bin/bash
#
# Instances at the top level of a SPICE file.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.333

cd ${WORK}
run_netgen ${TESTDIR}/read.tcl > read.log

expect_no_line read.log "Fatal|inside of itself" \
	"the file is read without errors"
expect_line read.log "^READ DONE" \
	"the file is read to the end"
expect_count read.log "^Device 'buf:[12]' Pins:" 2 \
	"both top-level instances are read"

finish ${status}
