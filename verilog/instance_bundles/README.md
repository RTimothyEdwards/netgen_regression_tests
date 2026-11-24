# instance_bundles

A verilog netlist connects wire bundles (e.g., `{a, s, x[3], c[0]}`) to
the pins of instances and of arrays of instances.  An entry of a bundle
can be a single wire, one bit of a bus, a range of a bus (`x[1:0]`), or a
whole bus (`c`).  The bits of the bundle are counted from the left, so
the first instance of an array (the left index) gets the first (left)
bits of the bundle.  A bundle that is the same width as the pin is
connected to every instance of the array.

Netgen assumed that every entry of a bundle sliced across an array was a
single bit of a bus (`name[index]`).  A single wire in the bundle made
netgen crash, or (with other netlists) produced nets named after the rest
of the bundle, such as `vdd_3v3,GND,s15_an[1]`.  A range or a whole bus in
the bundle was taken as one bit, and a bundle connected to a bus pin of an
array was not sliced across the array.

The verilog is compared twice against a SPICE netlist with the expected
connections:  once with the cells defined (in SPICE) before the verilog is
read, and once with the cells undefined, so that netgen makes placeholder
cells.  Fixed in netgen 1.5.334.
