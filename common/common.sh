#!/bin/bash
#
# common.sh --- Shared setup for netgen regression test scripts.
# Source this file from a test's run.sh after setting TESTDIR.
#
# Environment variables (all optional):
#
#   NETGEN          Command used to run netgen.  Default "netgen".  To test
#                   a build without installing it over an existing
#                   installation, configure it with "./configure
#                   --prefix=<dir>", run "make" and "make install", and use
#                   NETGEN=<dir>/bin/netgen.  The "Netgen <version>
#                   compiled on <date>" line at the start of a test's log
#                   shows which build ran.
#   KEEPWORK        If set, do not delete the test's work/ directory on
#                   success.
#   VALGRIND        If set, run netgen under valgrind (much slower).  A test
#                   then also fails if valgrind reports any memory errors;
#                   the reports are kept in the test's work/ directory as
#                   valgrind.<pid>.log.
#   IGNORE_VERSION  If set, run tests even if netgen is older than the
#                   version the test requires (for testing a build before
#                   its version number has been updated).

: ${NETGEN:=netgen}

WORK=${TESTDIR}/work
rm -rf ${WORK}
mkdir -p ${WORK}

# Run netgen in batch mode on a Tcl script.  All output goes to stdout so
# that it can be filtered or saved to a log.  The exit status is netgen's.

run_netgen() {
    if [ -n "${VALGRIND}" ]; then
	# The netgen command is normally a shell script, so follow it into
	# the programs it runs.
	valgrind --trace-children=yes --num-callers=30 \
		--log-file=${WORK}/valgrind.%p.log \
		${NETGEN} -batch source "$1" < /dev/null 2>&1
    else
	${NETGEN} -batch source "$1" < /dev/null 2>&1
    fi
}

# Under VALGRIND, check the valgrind reports in ${WORK}:  print a summary
# of any that found errors.  Returns 1 if any did, 0 otherwise.

check_valgrind() {
    local f bad=0
    [ -z "${VALGRIND}" ] && return 0
    for f in ${WORK}/valgrind.*.log; do
	[ -f "${f}" ] || continue
	if grep -q "ERROR SUMMARY: [1-9]" ${f}; then
	    echo "  valgrind:  $(grep -o 'ERROR SUMMARY: [0-9]* errors' ${f}) in $(basename ${f})"
	    grep -m1 -A4 "^==[0-9]*== [A-Z].*\(Invalid\|uninitialised\|Mismatched\|overlap\|Syscall\)" ${f} |
		    sed 's/^==[0-9]*== /    /'
	    bad=1
	fi
    done
    return ${bad}
}

# Print the version of netgen (e.g., "1.5.330"), or nothing if unknown.
# "netgen --version" prints only the version number (netgen 1.5.330 and
# later);  older versions print a banner "Netgen <version> compiled on
# <date>" when started, and then an error for "--version" (which is
# harmless in batch mode).  Accept either.

netgen_version() {
    ${NETGEN} -batch --version < /dev/null 2>&1 |
	    sed -n -e 's/^\([0-9][0-9]*\.[0-9][0-9.]*\)$/\1/p' \
		-e 's/^Netgen \([0-9][0-9.]*\) .*/\1/p' | head -n 1
}

# Skip the test (exit code 77) if netgen is older than the given version
# (e.g. "require_netgen_version 1.5.330").  Use this in a test that goes
# with a fix to netgen, giving the first version that has the fix, so that
# the test is skipped instead of failing when run with an older netgen.

require_netgen_version() {
    local have
    have=$(netgen_version)
    if [ -z "${have}" ]; then
	echo "  (could not get the netgen version;  running the test anyway)"
	return
    fi
    if [ "$(printf '%s\n%s\n' "$1" "${have}" | sort -V | head -n 1)" != "$1" ]; then
	if [ -n "${IGNORE_VERSION}" ]; then
	    echo "  (netgen ${have} is older than $1;  running anyway)"
	    return
	fi
	echo "SKIP: $(basename ${TESTDIR}) needs netgen $1 (this is ${have})"
	exit 77
    fi
}

# Checks on output files.  Each prints a line describing the result and
# sets the variable "status" to 1 on failure.  Patterns are extended
# regular expressions (grep -E).
#
#   expect_line <file> <pattern> <description>
#	Fail unless some line of <file> matches <pattern>.
#   expect_no_line <file> <pattern> <description>
#	Fail if any line of <file> matches <pattern>.
#   expect_count <file> <pattern> <count> <description>
#	Fail unless exactly <count> lines of <file> match <pattern>.

status=0

expect_line() {
    if grep -q -E -- "$2" "$1"; then
	echo "  ok:  $3"
    else
	echo "  FAIL:  $3"
	echo "         (no line matching \"$2\" in $(basename $1))"
	status=1
    fi
}

expect_no_line() {
    local found
    found=$(grep -m1 -E -- "$2" "$1")
    if [ -z "${found}" ]; then
	echo "  ok:  $3"
    else
	echo "  FAIL:  $3"
	echo "         (found in $(basename $1):  ${found})"
	status=1
    fi
}

expect_count() {
    local n
    n=$(grep -c -E -- "$2" "$1")
    if [ "${n}" = "$3" ]; then
	echo "  ok:  $4"
    else
	echo "  FAIL:  $4"
	echo "         (${n} lines matching \"$2\" in $(basename $1), expected $3)"
	status=1
    fi
}

# Print the lines of an LVS output file from "Final result:" to the end.

final_result() {
    sed -n '/^Final result:/,$p' "$1"
}

# Finish a test:  print PASS or FAIL and exit with status 0 or 1.
# Remove the work directory on success unless KEEPWORK is set.

finish() {
    if [ "$1" = "0" ] && ! check_valgrind; then
	set -- 1
    elif [ "$1" != "0" ]; then
	check_valgrind
    fi
    if [ "$1" = "0" ]; then
	echo "PASS: $(basename ${TESTDIR})"
	[ -z "${KEEPWORK}" ] && rm -rf ${WORK}
	exit 0
    else
	echo "FAIL: $(basename ${TESTDIR}) (see ${WORK})"
	exit 1
    fi
}
