# Elaborate id_prog.v with yosys for several values of ID, and compare
# each result against the gate-level netlist for ID = 8'ha5.
set dir [file dirname [file normalize [info script]]]
if {[info exists ::env(YOSYS)]} {set netgen::yosys_command $::env(YOSYS)}

proc try {name args} {
   global dir
   set v [netgen::yosys_elaborate $dir/id_prog.v id_prog -define USE_POWER_PINS \
		-stubs $dir/stubs.v {*}$args]
   puts "$name output: \"$v\""
   if {$v != {}} {
      lvs "$v id_prog" "$dir/gl_a5.v id_prog" nosetup $name.out
   }
}

try a5 -param {ID 8'ha5}
try decimal -param {ID 165}
try native -param {ID 8'ha5} -frontend verilog
try 5a -param {ID 8'h5a}
try default

# Without stubs, the pins of the cells are taken from their instances
set v [netgen::yosys_elaborate $dir/id_prog.v id_prog -define USE_POWER_PINS \
		-param {ID 8'ha5}]
puts "nostubs output: \"$v\""
if {$v != {}} {
   lvs "$v id_prog" "$dir/gl_a5.v id_prog" nosetup nostubs.out
}

# Errors are reported, and an empty string returned
puts "error output: \"[netgen::yosys_elaborate $dir/id_prog.v no_such_module]\""
