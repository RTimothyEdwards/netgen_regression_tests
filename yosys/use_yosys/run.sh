#!/bin/bash
#
# Requiring yosys to elaborate verilog that netgen can read.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.334
require_yosys

cd ${WORK}
for mode in auto always lvs fallback; do
    run_netgen ${TESTDIR}/${mode}.tcl > ${mode}.log
done

expect_line auto.log "^SETTING: auto" \
	"auto: use_yosys reports the setting"
expect_no_line auto.log "elaborated by yosys" \
	"auto: yosys is not used for a module netgen can read"
expect_line auto.out "^Final result: Circuits match uniquely" \
	"auto: netlists match"

expect_line always.log "^SETTING: always" \
	"always: use_yosys reports the setting"
expect_line always.log "^Note:  1 module that netgen read will also be elaborated by yosys" \
	"always: only the module with instances is given to yosys"
expect_line always.log "^Module top elaborated by yosys" \
	"always: yosys elaborates the module"
expect_line always.out "^Final result: Circuits match uniquely" \
	"always: netlists match"

expect_line lvs.log "^Module top elaborated by yosys" \
	"lvs -yosys: yosys elaborates the module"
expect_line lvs.log "^SETTING AFTER LVS: auto" \
	"lvs -yosys: the setting is restored after lvs"
expect_line lvs.out "^Final result: Circuits match uniquely" \
	"lvs -yosys: netlists match"

expect_line fallback.log "^Module top could not be elaborated by yosys;  netgen's reading of it is used" \
	"fallback: without yosys, netgen's reading of the module is used"
expect_line fallback.out "^Final result: Circuits match uniquely" \
	"fallback: netlists match"

finish ${status}
