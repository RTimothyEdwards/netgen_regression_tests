# Compare two copies of the same netlist (no setup file).
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/netlist1.spice]
set c2 [readnet spice $dir/netlist2.spice]
lvs "$c1 top" "$c2 top" nosetup comp.out
