# unordered_bus_pins

A verilog netlist connects a bus to a cell defined in SPICE, where the
cell's bus pins are not listed in index order.  Here they are sorted
alphabetically, as some tools write them:  `D[0] D[10] D[11] D[1] D[2] ...
D[9]`.

Netgen used to take the bus range from the first and last pins in the
list, so it saw `D` as `D[0:9]`:  it connected only 10 of the 12 bits,
connected those in reverse order, and left the rest unconnected ("Implicit
pin").  The full range of indexes is now used.  Fixed in netgen 1.5.329.
