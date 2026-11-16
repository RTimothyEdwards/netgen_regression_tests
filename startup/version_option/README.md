# version_option

`netgen --version` prints only the version number (for example,
`1.5.330`) on standard output and exits with status 0, without starting
the console or printing the startup banner.  This is what the regression
tests use to find the version of netgen being tested (see
`netgen_version` in `common/common.sh`).

Previously, `netgen --version` started the console and reported
`invalid command name "--version"`.  Added in netgen 1.5.330.
