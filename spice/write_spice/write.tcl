# Write the cell "top" as SPICE, read the file back, and compare it with
# the original.
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/input.spice]
writenet spice top $c1
puts "WRITTEN"
set c2 [readnet spice top.spice]
puts "READ BACK"
lvs "$c1 top" "$c2 top" nosetup comp.out
