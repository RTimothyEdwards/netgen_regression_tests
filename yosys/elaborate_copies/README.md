# elaborate_copies

A verilog module that netgen cannot read is elaborated by yosys when the
netlist is compared, once for each set of parameter values passed to it.

`chip.v` defines `id_prog` (the same as in `yosys/elaborate_proc`:  each
bit of an 8-bit output is connected to a tie-high or tie-low cell, chosen
by the parameter `ID` in a `generate` loop), and `chip`, which has three
instances of it:  with `ID = 8'ha5`, with `ID = 8'h3c`, and with the
default value.  Netgen's verilog reader cannot evaluate the `assign`
statements in the loop, so it marks `id_prog` to be elaborated by yosys.

When the netlists are compared, yosys elaborates `id_prog` with its
default parameters, and then makes a copy (`id_prog@1`, etc.) for each
value of `ID`.  These are compared against `layout.spice`, a flat netlist
of the tie cells, which must match, and `layout_bad.spice`, which has one
bit wrong, which must not.

`defs.v` defines `USE_POWER_PINS`, and is read into the netlist before
`chip.v` so that netgen reads the power pins of `id_prog`.  Netgen passes
the same definitions to yosys.

Skipped if yosys is not found or cannot be used.  Added in netgen 1.5.331.
