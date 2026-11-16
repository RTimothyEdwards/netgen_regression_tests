# Compare the SPICE layout against body.v (using the SPICE cell "res")
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/res.spice]
readnet verilog $dir/body.v $c2
lvs "$c1 top" "$c2 top" nosetup body.out
