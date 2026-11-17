# unreadable_module

A verilog module that netgen's verilog reader cannot read:  `gen` has a
generate loop whose bound is a parameter of the module header.  Netgen
marks such a module to be elaborated by yosys (see `yosys/`);  here yosys
is not used (`netgen::yosys_use` is 0), so the module is a black box.

Netgen must report the module, and must go on to read the rest of the
file (module `after`).  The module is used (by `user`) before it is
defined, so it is first made as a placeholder cell, which the definition
must replace under the module's own name.

In netgen 1.5.331 and earlier, the loop that could not be read ended the
reading of the file, so `after` was missing, and the module was left as
a cell named `_PLACEHOLDER_`.  Fixed in netgen 1.5.331.
