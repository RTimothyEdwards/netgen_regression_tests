# generate_loop

A verilog module makes instances in two generate `for` loops, one with a
block label (`begin : g`) and one without.  Netgen reads these loops
itself (they do not need yosys).

Netgen used to go wrong in three ways:

- The last pass through a loop was read with the loop variable already
  removed, so expressions using it ("`y[2*i]`") could not be evaluated, and
  the last instance was left unconnected.
- A block label was read as the start of an instance, making a
  placeholder cell named `:`.
- Each instance was named with the loop index twice (`u[0][0]`).

The instances are compared against a SPICE netlist with the expected
connections, and each is looked up by its expected name (`u[0]`).  Fixed
in netgen 1.5.333.
