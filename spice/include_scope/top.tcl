# Case 2:  .include at the top level, between top-level devices
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/top_layout.spice]
set c2 [readnet spice $dir/top_include.spice]
# The top-level cell of a file is named after the file (as read)
lvs "$c1 $dir/top_layout.spice" "$c2 $dir/top_include.spice" nosetup top.out
