# Flatten a cell before comparing, as some LVS scripts do.
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/schematic.spice]
flatten "$c2 chain"
lvs "$c1 top" "$c2 top" nosetup comp.out
