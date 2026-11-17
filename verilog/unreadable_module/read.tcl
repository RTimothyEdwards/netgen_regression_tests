# Read design.v without using yosys, and list the cells read
set dir [file dirname [file normalize [info script]]]
set netgen::yosys_use 0
set c [readnet spice $dir/res.spice]
readnet verilog $dir/design.v $c
puts "cells: [lsort [cells list]]"
puts "gen has contents: [contents -check "gen $c"]"
