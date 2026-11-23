# top_level_instances

A SPICE file defines subcircuits and then instances them at the top level
of the file (outside of any `.subckt`).  The last subcircuit defined,
`buf`, contains only subcircuit instances, and it is instanced at the top
level.

The SPICE reader checks that a subcircuit does not instance itself.  It
used to compare each instance against the name of the last subcircuit
read, even after its `.ENDS` (unless a device with a model had been read
since), so it reported "Class "buf" is instanced inside of itself!" and
stopped reading the file.  The check now applies only inside a
subcircuit, against the subcircuit being read.  Fixed in netgen 1.5.333.
