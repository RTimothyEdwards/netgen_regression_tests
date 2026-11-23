# Compare with the cells not defined, so that netgen makes placeholder
# cells, taking the width of each pin from the first instance array.
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet verilog $dir/top.v]
lvs "$c1 top" "$c2 top" nosetup placeholder.out -blackbox
