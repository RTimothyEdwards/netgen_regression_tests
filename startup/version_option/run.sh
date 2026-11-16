#!/bin/bash
#
# "netgen --version" prints only the version number.  See README.md.

TESTDIR=$(cd $(dirname $0) && pwd)
source ${TESTDIR}/../../common/common.sh
require_netgen_version 1.5.330

cd ${WORK}

# Without -batch, an older netgen would start the console, so limit the time
timeout 60 ${NETGEN} --version < /dev/null > version.out 2> version.err
code=$?

if [ ${code} -eq 0 ]; then
    echo "  ok:  exit status 0"
else
    echo "  FAIL:  exit status ${code}, expected 0"
    status=1
fi
expect_count version.out "" 1 \
	"one line of output"
expect_line version.out "^[0-9]+\.[0-9]+\.[0-9]+$" \
	"output is a version number"

finish ${status}
