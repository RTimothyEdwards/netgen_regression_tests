# Flatten "cell" in "top" by name before comparing, as a setup file might.
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet spice $dir/schematic.spice]
if {[catch {flatten class top "$c2 cell"} msg]} {
   puts stdout "FLATTEN ERROR: $msg"
}
lvs "$c1 top" "$c2 top" nosetup comp.out
