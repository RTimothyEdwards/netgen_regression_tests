# Compare the generated instances against the expected connections, and
# print the pins of each instance by its expected name.
set dir [file dirname [file normalize [info script]]]
set c1 [readnet spice $dir/layout.spice]
set c2 [readnet verilog $dir/top.v]
foreach inst {u[0] u[1] v[0] v[1] v[2]} {
    nodes $inst "top $c2"
}
lvs "$c1 top" "$c2 top" nosetup comp.out
