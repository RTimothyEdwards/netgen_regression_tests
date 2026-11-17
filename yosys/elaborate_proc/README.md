# elaborate_proc

The `netgen::yosys_elaborate` procedure, which runs yosys (version 0.67 or
newer, with the `read_slang` front end) to elaborate a verilog module for a
given set of parameter values, and returns the name of a file with the
result as a simple structural netlist that netgen can read.

`id_prog.v` is a small version of a "user ID" block:  each bit of an 8-bit
output is connected to a tie-high or tie-low cell, chosen by the value of
the parameter `ID` in a `generate` loop.  Netgen's own verilog reader
cannot evaluate this.  The result for each value of `ID` is compared
against `gl_a5.v`, a gate-level netlist for `ID = 8'ha5`:

- `8'ha5`, `165` (decimal), and `8'ha5` with yosys's own verilog reader
  (`-frontend verilog`) must match.
- `8'h5a`, and the default value `8'h0f`, must not match.  (These have
  the same number of bits high as `8'ha5`, so the difference is found when
  matching pins.)

The cells are given to yosys as black boxes (`stubs.v`).  Without them,
the procedure must find that the cells are not defined, and take their
pins from their instances (as netgen does for placeholder cells), and the
result must still match.  An error (here, a module that does not exist)
must be reported, and an empty string returned.

The unused tie cells and the decap cells (included because `LVS` is
defined) have outputs that are not used or no connections at all;  they
must be kept in the output (yosys's "opt_clean" would remove them).

Skipped if yosys is not found or cannot be used (see `require_yosys` in
`common/common.sh`).  Added in netgen 1.5.331.
