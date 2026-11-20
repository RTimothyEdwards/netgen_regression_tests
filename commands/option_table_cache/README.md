# Tcl option table lifetime

`Tcl_GetIndexFromObj` caches the table address and matching index in the Tcl
object. A stack-allocated table can reuse another command's table address,
so reusing the same option object can select the wrong operation or accept
an option that is invalid for the current command.

These twelve cases cover SPICE and Verilog read/write dispatch, shared
literals and variables, unique abbreviations, `readlib`, reading an export,
and rejection of options that are invalid or ambiguous in the destination
command. Each case starts a new Netgen process and checks the output file
extension and format marker, or the specific Tcl error. No PDK is needed;
the SPICE input intentionally uses a placeholder cell.

The failure depends on compiler stack layout. With GCC 11.4, `-O1` and
AddressSanitizer, unmodified Netgen 1.5.331 writes Wombat for `spice`, writes
ESACAP for `verilog`, and accepts `readnet wombat`. An ordinary build may
not exhibit those failures; the required behavior is the same in either
build. This test does not require ASan and does not change the format
object to avoid the cache.

The ordinary GCC 11.4 build also accepts `resolve` as an option to
`summary` or `exhaustive` after `run resolve`, and accepts `nodes` as an
option to `run` after `summary nodes`. The rejection cases catch these
cross-command errors without requiring an ASan build.

This companion PR stays draft until the source fix is released. Add
`require_netgen_version` with the actual first fixed release in `run.sh`
before merging.
