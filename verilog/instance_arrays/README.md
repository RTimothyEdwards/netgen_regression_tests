# instance_arrays

A verilog netlist has arrays of instances (e.g., `sub2 u1[1:3] (...)`)
whose pins are connected to buses.  The array and the bus can each be
declared in either direction (`[1:0]` or `[0:1]`).  The first instance of
the array (the left index) gets the first (left) bits of the bus.  A bus
that is the same width as the pin, or a single bit, is connected to every
instance of the array.

Netgen used to go wrong in several of these cases:

- When the array and the bus ran in opposite directions and the cell was
  not defined, netgen crashed (divide by zero) while making a placeholder
  cell.
- A bus declared low-to-high (`[0:3]`) connected to a bus pin was not
  connected at all ("Implicit pin").
- A single bit, or a bus the same width as the pin, was sliced across the
  instances, so that each instance got a different bit (e.g., `x[3]` on
  one instance and `x[2]` on the next) instead of the same one.
- An array declared low-to-high with a first index other than zero
  (e.g., `[1:3]`) got the wrong slices of the bus.

The verilog is compared twice against a SPICE netlist with the expected
connections:  once with the cells defined (in SPICE) before the verilog is
read, and once with the cells undefined, so that netgen makes placeholder
cells.  Fixed in netgen 1.5.332.
