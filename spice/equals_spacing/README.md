# equals_spacing

In a SPICE netlist, a property or parameter may be written with spaces
around the equals sign:  `key = value`, `key= value`, or `key =value`.
These must be read the same as `key=value`.  A property written as `key=`
with no value (here, at the end of a line, followed by a continuation line
that gives the same property again) is ignored.

The schematic writes properties and a `.param` in each of these ways;  the
layout gives the same values as numbers.

Netgen used to split `key= value` into a property with no value followed
by a separate token, so the value was lost (and reported as an unresolved
expression).  Fixed in netgen 1.5.330.
