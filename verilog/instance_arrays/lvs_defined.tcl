# Compare with the cells defined (in SPICE) before the verilog is read.
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/cells.spice]
readnet verilog $dir/top.v $c2
lvs "$c1 top" "$c2 top" nosetup defined.out
