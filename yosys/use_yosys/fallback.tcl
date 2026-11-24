# use_yosys always, but yosys cannot be run (see compare.tcl)
set nosuchyosys 1
set out fallback
set mode always
source [file join [file dirname [file normalize [info script]]] compare.tcl]
