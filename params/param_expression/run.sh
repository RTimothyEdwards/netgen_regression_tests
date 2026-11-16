#!/bin/bash
#
# The value of a .param may be an expression in terms of other parameters.  See README.md.

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

# A circular parameter definition must be reported, and must not hang.
cat > circular.tcl << EOF
readnet spice ${TESTDIR}/circular.spice
EOF
timeout 60 bash -c "$(declare -f run_netgen); NETGEN='${NETGEN}' WORK='${WORK}' VALGRIND='${VALGRIND}' run_netgen circular.tcl" > circular.log
code=$?
if [ ${code} -eq 124 ]; then
    echo "  FAIL:  circular parameter definition (netgen did not finish)"
    status=1
else
    expect_line circular.log "circular definition" \
	    "circular parameter definition is reported"
fi

finish ${status}
