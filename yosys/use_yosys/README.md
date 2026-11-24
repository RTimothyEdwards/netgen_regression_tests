# use_yosys

`use_yosys always` has yosys elaborate every verilog module that has
instances, even if netgen can read the module itself, and the `lvs`
option `-yosys` does the same for the netlist files that `lvs` reads.
Modules without instances (here the black boxes `sub1` and `sub2`) are
left as netgen read them.  If yosys cannot elaborate a module that netgen
read, netgen's reading of it is used (instead of making it a black box).

The module `top` (instance arrays, which netgen can read) is compared
against a SPICE netlist with the expected connections four ways:

- `auto` (the default):  yosys is not used.
- `always`:  yosys elaborates `top`.
- `lvs ... -yosys` (with `lvs` reading the files):  yosys elaborates
  `top`, and the setting is restored afterwards.
- `always`, with `netgen::yosys_command` set to a command that does not
  exist:  netgen's reading of `top` is used.

Added in netgen 1.5.334.
