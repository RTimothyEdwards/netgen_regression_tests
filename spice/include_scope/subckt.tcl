# Case 1:  .include inside a subcircuit
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/subckt_layout.spice]
set c2 [readnet spice $dir/subckt_include.spice]
lvs "$c1 top" "$c2 top" nosetup subckt.out
