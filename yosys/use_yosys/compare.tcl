# Compare top.v against the layout.  "mode" is set by the script that
# sources this one:  the setting for "use_yosys", or "lvs" to use the
# "-yosys" option of "lvs" (with "lvs" reading the files).  The output
# file is <out>.out ("out" is "mode" unless set).
set dir [file dirname [file normalize [info script]]]
if {[info exists ::env(YOSYS)]} {set netgen::yosys_command $::env(YOSYS)}
if {[info exists nosuchyosys]} {set netgen::yosys_command no_such_yosys_command}
if {![info exists out]} {set out $mode}
if {$mode == "lvs"} {
    lvs "$dir/layout.spice top" "$dir/top.v top" nosetup $out.out -blackbox -yosys
    puts "SETTING AFTER LVS: [use_yosys]"
} else {
    use_yosys $mode
    puts "SETTING: [use_yosys]"
    set c1 [readnet spice $dir/layout.spice]
    set c2 [readnet verilog $dir/top.v]
    lvs "$c1 top" "$c2 top" nosetup $out.out -blackbox
}
