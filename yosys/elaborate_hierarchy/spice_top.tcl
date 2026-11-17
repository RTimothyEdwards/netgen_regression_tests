# Compare top.spice (using the verilog modules) against the layout
set dir [file dirname [file normalize [info script]]]
if {[info exists ::env(YOSYS)]} {set netgen::yosys_command $::env(YOSYS)}
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/res.spice]
readnet verilog $dir/modules.v $c2
readnet spice $dir/top.spice $c2
lvs "$c1 top" "$c2 top" nosetup spice_top.out
