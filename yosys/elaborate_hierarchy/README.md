# elaborate_hierarchy

A verilog module elaborated by yosys, within a hierarchy of cells that
pass parameters to each other.

`mid` has a generate loop whose bound is its parameter `N`, which netgen's
verilog reader cannot evaluate, so it is elaborated by yosys.  In the loop,
`mid` passes a different value of `W` (`i + 5`) to each instance of
`child`, which netgen reads itself, and which passes `W` on to the SPICE
subcircuit `res` as its parameter `L`.  `top` uses `mid` with `N = 3`, so
there must be three transistors, with `L` = 5, 6, and 7 (`layout.spice`).

Since `mid` is given only one set of parameters (`N = 3`, which is not its
default), yosys elaborates it again in place (keeping its name), and the
values of `W` that yosys computes are then passed down by netgen as for
any other subcircuit.

- `verilog_top.tcl`:  `top` is in verilog (`design.v`).
- `spice_top.tcl`:  `top` is a SPICE netlist (`top.spice`) using the
  verilog modules (`modules.v`), and passing `N=3` as a SPICE parameter.
  Netgen 1.5.331 and earlier reported every SPICE instance of a verilog
  module as an error ("SPICE subcircuit mid redefines a verilog module").

Skipped if yosys is not found or cannot be used.  Added in netgen 1.5.331.
