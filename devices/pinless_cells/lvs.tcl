set dir [file dirname [file normalize [info script]]]
lvs "$dir/layout.v top" "$dir/schematic.v top" nosetup comp.out
