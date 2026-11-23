# Read the file, then print the pins of each top-level instance.  The top
# level of the file is a cell named for the file.
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/input.spice]
puts "READ DONE"
foreach inst {buf:1 buf:2} {
    nodes $inst "$dir/input.spice $c1"
}
