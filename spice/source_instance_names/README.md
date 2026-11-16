# source_instance_names

The instance names of voltage sources (`V`), current sources (`I`), and
voltage-controlled voltage sources (`E`) read from SPICE must be their own
names.

Netgen did not set the instance name for these devices, so each one got
the name of whatever device had been read before it.  Depending on what
was left in memory, that could be another device's name, the name from a
different netlist, or garbage, which then led to wrong property comparisons
(including garbage property values).  Fixed in netgen 1.5.330.

The netlists here start with sources, before any other device, and give
`Vb` a different value in the layout, so that its name is printed in the
list of property errors.
