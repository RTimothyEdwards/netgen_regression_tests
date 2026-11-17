# Compare the SPICE layout against sized.v (using the SPICE cell "res")
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/res.spice]
readnet verilog $dir/sized.v $c2
lvs "$c1 top" "$c2 top" nosetup sized.out
