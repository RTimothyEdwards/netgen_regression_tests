# cdl_escaped_bus

A verilog netlist instantiates a cell that is defined in a CDL (SPICE)
netlist.  Two differences between verilog and SPICE naming must be
reconciled:

- The CDL cell has pins `VDD!` and `VSS!`, which in verilog must be written
  as escaped names, `.\VDD! (vdd)` and `.\VSS! (vss)`.
- The CDL cell has bus pins `A<1>` and `A<0>` (angle brackets), connected
  in verilog as a bus, `.A({x[1], x[0]})`.

Netgen used to report "Instance ... has pin \VSS! which is not in the mem
cell definition" and the same for `A`, and left the pins unconnected
("Implicit pin").  Fixed in netgen 1.5.328.
