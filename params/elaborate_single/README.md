# elaborate_single

A subcircuit whose instances all pass it the same parameter values (here,
different from its defaults) is resolved with those values and keeps its
name, so that it is compared directly against the cell of the same name in
the other netlist.

In the schematic, `cell` declares `W=1` and its transistor has `W='W'`.
Both instances of `cell` pass `W=2`.  The layout's `cell` has a transistor
with `W=2`.  The top cell is listed before `cell` is defined, so the
parameters are passed to a cell that is not yet defined when the instance
is read.

The parameters must also be removed from the instances of `cell` once
their values are part of the cell, or they are reported as properties that
have no match in the layout.

Netgen used to resolve `W='W'` with the default value when the netlist was
read, giving `W=1`.  Elaboration was added in netgen 1.5.330.
