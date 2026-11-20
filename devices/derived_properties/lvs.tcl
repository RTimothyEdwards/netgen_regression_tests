set dir [file dirname [file normalize [info script]]]
set layout_dims {l=7u w=7u}
switch -- $::env(DERIVE_CASE) {
    match {set source_dims {w=7.0e-6 l=7.0e-6}}
    area_mismatch {set source_dims {w=10u l=7u}}
    perimeter_mismatch {set source_dims {w=14u l=3.5u}}
    swapped {
        set layout_dims {l=3u w=5u}
        set source_dims {w=3u l=5u}
    }
    default {error "Unknown case $::env(DERIVE_CASE)"}
}
set layout "$::env(DERIVE_NAME).spc"
set f [open $layout w]
puts $f ".subckt top A B\nX0 A B cap_mim $layout_dims\n.ends top"
close $f
set f [open source.spice w]
puts $f ".subckt top A B\nX1 A B cap_mim $source_dims m=1\n.ends top"
close $f
lvs [list $layout top] {source.spice top} $dir/setup.tcl comp.out
