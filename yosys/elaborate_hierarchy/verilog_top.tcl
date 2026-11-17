# Compare design.v (top in verilog) against the layout
set dir [file dirname [file normalize [info script]]]
if {[info exists ::env(YOSYS)]} {set netgen::yosys_command $::env(YOSYS)}
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/res.spice]
readnet verilog $dir/design.v $c2
lvs "$c1 top" "$c2 top" nosetup verilog_top.out
