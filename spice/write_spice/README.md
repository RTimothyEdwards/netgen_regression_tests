# write_spice

A SPICE netlist with subcircuits, transistors, resistors, and a capacitor
is written with `writenet spice`, and the file is read back.

The SPICE writer used to crash (a segmentation fault) at the end of the
cell, and the file it wrote was wrong:  each instance was missing its
first pin and had the pins of the following instance, pins were named
by instance pin (`u/A`) instead of by net, and the `.SUBCKT` line listed
node numbers.  Resistor and capacitor values were not written.

Reading such a file back also failed:  an instance of `inv` at the top
level of the file, after the `.ENDS` of `inv`, was reported by the SPICE
reader as "Class "inv" is instanced inside of itself!", ending the read.

The top cell used to be written as the top level of the file, without
its pins;  it is now written as a subcircuit.  The file read back is
compared with the original.  Fixed in netgen 1.5.333.
