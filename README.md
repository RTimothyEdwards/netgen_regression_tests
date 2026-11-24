# Netgen regression tests

Examples and regression tests for the [netgen](https://github.com/RTimothyEdwards/netgen)
LVS (netlist comparison) tool.  These are kept separate from the netgen
source repository so that test cases can be added freely.

## Running the tests

```
./run_tests.sh              # run all tests
./run_tests.sh params       # run all tests under params/
./run_tests.sh -j 1         # run the tests one at a time
./params/local_param/run.sh # run one test
```

Each test prints a summary of what it checked and ends with a line
`PASS: <name>`, `FAIL: <name>`, or `SKIP: <reason>`.  `run_tests.sh`
prints a count of each at the end and exits non-zero if any test failed.

`run_tests.sh` runs up to 20 tests at the same time (set with `-j <n>` or
the `JOBS` variable).  Each test's output is shown when it finishes, with
the time it took, so the tests are listed in the order they finish.  With
`-j 1` they run in order and their output is shown as they run.  Because
tests run at the same time, a test must not write anywhere outside its own
directory.  Running in parallel needs bash 5.1 or newer.

Environment variables:

| Variable         | Default  | Meaning |
|------------------|----------|---------|
| `NETGEN`         | `netgen` | Command used to run netgen |
| `KEEPWORK`       | (unset)  | Keep each test's `work/` directory even if the test passes |
| `VALGRIND`       | (unset)  | Run netgen under valgrind;  a test also fails if valgrind reports memory errors (reports are kept in `work/`).  Much slower:  for occasional runs.  Note that netgen allocates memory through Tcl, and a threaded Tcl manages small blocks itself, so valgrind does not see all errors. |
| `MEMLIMIT`       | `4000000` | Memory limit (kilobytes, `ulimit -v`) for each run of netgen, so that a test that makes netgen loop without end fails instead of using up the machine's memory.  Not applied under `VALGRIND`. |
| `TIMELIMIT`      | `300`    | Time limit (seconds) for each run of netgen (10 times as long under `VALGRIND`) |
| `IGNORE_VERSION` | (unset)  | Run tests that need a newer version of netgen than the one being tested, instead of skipping them (for testing a fix before the version number has been updated) |
| `JOBS`           | `20`     | Number of tests to run at the same time (`-j` overrides it) |
| `YOSYS`          | `yosys`  | Command used to run yosys.  Tests that use yosys are skipped if it is not found, is older than version 0.67, or does not have the `read_slang` command. |

To test a build of netgen without installing it over an existing
installation, configure it with `./configure --prefix=<dir>`, then `make`
and `make install`, and run:

```
NETGEN=<dir>/bin/netgen ./run_tests.sh
```

The "Netgen <version> compiled on <date>" line at the start of a test's log
(`work/lvs.log`, kept with `KEEPWORK`) shows which build ran.

## Automatic runs on GitHub

The tests are run on GitHub by the workflows in `.github/workflows/`:

- `regression.yml` builds netgen and runs all of the tests.  It is a
  reusable workflow, called by:
  - the netgen repository's `.github/workflows/regression.yml`, for every
    pull request to netgen, so the result appears as a check on the pull
    request;
  - `nightly.yml` in this repository, which tests the netgen `master`
    branch every night, whenever the tests change, and on request (from the
    "Actions" tab, "Run workflow").
- If any test fails, the `work/` directories of the failed tests are saved
  as a downloadable artifact of the workflow run.

## Writing a test

A test is a directory containing an executable `run.sh`, which sources
`common/common.sh`, runs netgen with `run_netgen <script.tcl>` in the
test's `work/` directory, checks the output with `expect_line`,
`expect_no_line`, and `expect_count`, and ends with `finish ${status}`.
A test that goes with a fix to netgen calls `require_netgen_version` with
the first version that has the fix, so that it is skipped (not failed)
when run with an older netgen.  See the existing tests for examples.

Netlists in tests should be small and written for the case being tested,
not copied from user designs.  Checks should look for specific lines of
the output, not compare whole output files, so that changes to the format
of unrelated output do not cause failures.  Each test has a `README.md`
describing what it checks and why.

## Layout

```
.github/workflows/    GitHub workflows (see above)
run_tests.sh          Runs all tests (any directory containing run.sh)
common/common.sh      Shared setup and helper functions for run.sh scripts
commands/            Tcl command options
    option_table_cache/  Cached options remain local to their command table
blackbox/             Cells compared as black boxes
    one_sided_summary/  Listing of cells with contents in only one netlist
    pin_names/        Black box pins must match by name
    placeholder_pins/ Pins of placeholder (undefined) devices are compared
devices/              Device and instance matching
    derived_properties/ Derived area/perimeter values and per-instance state
    pinless_cells/    Merged cells that have no pins
params/               SPICE parameters
    elaborate_expressions/  Defaults and local parameters that are expressions
    elaborate_flatten/  "flatten class" applies to copies of a subcircuit
    elaborate_nested/  Parameters passed through two levels of subcircuits
    elaborate_single/ Subcircuit given one set of parameters (resolved in place)
    elaborate_standalone/  Copied subcircuit compared on its own (defaults)
    elaborate_variants/  Subcircuit given several sets (copied for each set)
    local_param/      .param inside a subcircuit is local to it
    param_before_definition/  Parameters used before they are defined
    param_expression/ .param values that are expressions;  circular definitions
    subckt_param_scope/  .subckt parameters take precedence over globals
pins/                 Pin matching
    full_pin_list/    Pin list is complete when the netlists do not match
results/              Final result reported by "lvs"
    net_mismatch_message/  A net mismatch is reported as such
    pin_mismatch_message/  A pin-only mismatch is reported as such
spice/                SPICE netlist reading and writing
    equals_spacing/   Spaces around "=" in properties and parameters
    include_scope/    Files read with .include are part of the including file
    source_instance_names/  Instance names of V, I, and E sources
    top_level_instances/  Instances outside of any subcircuit
    unresolved_expression/  Unresolved expressions reported as such
    write_spice/      Writing a netlist with "writenet spice"
startup/              Starting netgen
    version_option/   "netgen --version" prints the version number
verilog/              Verilog netlists
    cdl_escaped_bus/  Verilog instance of a CDL cell (escaped names, <> buses)
    generate_loop/    Instances made by generate "for" loops
    instance_arrays/  Instance arrays and buses declared in either direction
    parameters/       Parameters passed through verilog modules
    sized_constants/  Parameter values given as based constants (32'd10)
    unordered_bus_pins/  Bus connected to a cell with unordered bus pins
    unreadable_module/  Module netgen cannot read (yosys not used)
yosys/                Using yosys to elaborate verilog
    elaborate_copies/  Copies made by yosys for each set of parameters
    elaborate_hierarchy/  Module elaborated by yosys within a hierarchy
    elaborate_proc/   The netgen::yosys_elaborate procedure
    use_yosys/        Requiring yosys ("use_yosys always", "lvs -yosys")
```
