# Compare chip.v against the layout;  "id_prog" is elaborated by yosys.
set dir [file dirname [file normalize [info script]]]
if {[info exists ::env(YOSYS)]} {set netgen::yosys_command $::env(YOSYS)}
# "layout" is set by the script that sources this one
set c1 [readnet spice $dir/$layout.spice]
set c2 [readnet verilog $dir/defs.v]
readnet spice $dir/cells.spice $c2
readnet verilog $dir/chip.v $c2
lvs "$c1 chip" "$c2 chip" nosetup $layout.out
