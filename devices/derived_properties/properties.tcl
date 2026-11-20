# Read the public SPICE export to check the properties of individual
# instances, including cases whose missing dimensions must remain missing.
proc exported_properties {cell fnum} {
    # Use a fresh format object: readnet and writenet have different option
    # tables, and their stack addresses can alias Tcl's cached index lookup.
    writenet [string tolower SPICE] $cell $fnum
    set f [open "$cell.spice" r]
    set text [read $f]
    close $f
    set records {}
    set current {}
    foreach line [split $text \n] {
        if {[regexp {^X[^ ]*:([^ /]+)\s} $line -> name]} {
            set current $name
            dict set records $current {}
        } elseif {![regexp {^\s+\S} $line]} {
            set current {}
        }
        if {$current == {}} {continue}
        foreach {whole key value} [regexp -all -inline \
                {([A-Za-z_][A-Za-z_0-9]*)=([-+0-9.eE]+)} $line] {
            set key [string tolower $key]
            if {[dict exists $records $current $key]} {
                error "CHECK FAILED: duplicate $key on $cell/$current"
            }
            dict set records $current $key $value
        }
    }
    return $records
}

proc has_value {records instance key expected} {
    if {![dict exists $records $instance $key]} {
        error "CHECK FAILED: $instance has no $key"
    }
    set actual [dict get $records $instance $key]
    if {abs($actual - $expected) > 1e-6 * abs($expected)} {
        error "CHECK FAILED: $instance $key=$actual, expected $expected"
    }
}

proc lacks_value {records instance key} {
    if {![dict exists $records $instance]} {
        error "CHECK FAILED: missing instance $instance"
    }
    if {[dict exists $records $instance $key]} {
        error "CHECK FAILED: $instance unexpectedly has $key"
    }
}

proc check_properties {} {
    set f [open input.spice w]
    puts $f {.subckt top A B C D E F G H}
    puts $f {X0 A B cap_mim w=7u l=7u marker=17}
    puts $f {X1 B C cap_mim l=3u}
    puts $f {X2 C D cap_mim w=5u}
    puts $f {X3 D E cap_mim w=7u l=7u area=99p marker=23}
    puts $f {X4 E F cap_mim w=3u l=5u perimeter=44u}
    puts $f {X5 F G cap_mim l=2u w=4u area=88p perimeter=55u}
    puts $f {X6 G H cap_mim l=3u w=4u marker=31}
    puts $f {.ends top}
    # Multiple cells exercise the callback's continue-walking contract.
    for {set i 0} {$i < 12} {incr i} {
        puts $f ".subckt holder_$i A B"
        puts $f "X0 A B cap_mim w=[expr {$i + 1}]u l=2u"
        puts $f ".ends holder_$i"
    }
    close $f
    set f1 [readnet spice input.spice]
    set f [open other.spice w]
    puts $f {.subckt untouched A B}
    puts $f {X0 A B cap_mim w=11u l=13u}
    puts $f {.ends untouched}
    close $f
    set f2 [readnet spice other.spice]

    property default
    set order {area perimeter}
    if {$::env(DERIVE_ORDER) == "perimeter_first"} {
        set order {perimeter area}
    }
    # Repeating the operation must preserve existing values, not append
    # duplicates, drop a property, or reuse another instance's state.
    foreach repeat {1 2} {
        foreach derived $order {
            property "cap_mim $f1" derive $derived w l
        }
    }
    set p [exported_properties top $f1]
    if {[dict size $p] != 7} {error "CHECK FAILED: expected seven instances"}
    foreach {inst key expected} {
        0 w 7e-6  0 l 7e-6  0 marker 17  0 area 49e-12  0 perimeter 28e-6
        1 l 3e-6
        2 w 5e-6
        3 w 7e-6  3 l 7e-6  3 marker 23  3 area 99e-12  3 perimeter 28e-6
        4 w 3e-6  4 l 5e-6  4 area 15e-12  4 perimeter 44e-6
        5 w 4e-6  5 l 2e-6  5 area 88e-12  5 perimeter 55e-6
        6 w 4e-6  6 l 3e-6  6 marker 31  6 area 12e-12  6 perimeter 14e-6
    } {
        has_value $p $inst $key $expected
    }
    foreach {inst key} {1 w 1 area 1 perimeter 2 l 2 area 2 perimeter} {
        lacks_value $p $inst $key
    }
    for {set i 0} {$i < 12} {incr i} {
        set p [exported_properties holder_$i $f1]
        has_value $p 0 area [expr {($i + 1) * 2e-12}]
        has_value $p 0 perimeter [expr {2 * ($i + 3) * 1e-6}]
    }
    set p [exported_properties untouched $f2]
    has_value $p 0 w 11e-6
    has_value $p 0 l 13e-6
    lacks_value $p 0 area
    lacks_value $p 0 perimeter
}

if {[catch {check_properties} message]} {
    puts stderr "CHECK FAILED: $message"
    exit 1
}
puts "PROPERTY CHECKS PASSED"
