# Compare the schematic against the layout (no setup file).
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/schematic.spice]
lvs "$c1 top" "$c2 top" nosetup comp.out
