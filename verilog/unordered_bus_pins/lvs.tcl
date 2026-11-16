# Compare the layout against the verilog netlist using a SPICE cell.
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/fab.spice]
readnet verilog $dir/top.v $c2
lvs "$c1 top" "$c2 top" nosetup comp.out
