proc check_output {filename pattern} {
    if {![file exists $filename]} {
        error "CHECK FAILED: expected $filename, got [glob -nocomplain top.*]"
    }
    if {[lsort [glob top.*]] ne [list $filename]} {
        error "CHECK FAILED: unexpected output format: [glob top.*]"
    }
    set f [open $filename r]
    set text [read $f]
    close $f
    if {![regexp $pattern $text]} {
        error "CHECK FAILED: $filename does not contain the requested format"
    }
}

proc must_reject {command prefix} {
    set code [catch {uplevel 1 $command} message]
    if {$code != 1 || ![string match "$prefix *" $message]} {
        error "CHECK FAILED: expected '$prefix' error, got code $code: $message"
    }
}

proc check_option {} {
    switch -- $::env(OPTION_CASE) {
        literal_spice {
            # The interpreter may share the literal object across commands.
            set f [netgen::readnet spice input.spice]
            netgen::writenet spice top $f
            check_output top.spice {^SPICE deck for cell top }
        }
        shared_spice - abbreviated_spice {
            set fmt spice
            if {$::env(OPTION_CASE) eq "abbreviated_spice"} {set fmt sp}
            # Deliberately pass the same object, without rebuilding its string.
            set f [netgen::readnet $fmt input.spice]
            netgen::writenet $fmt top $f
            check_output top.spice {^SPICE deck for cell top }
        }
        shared_verilog - abbreviated_verilog {
            set fmt verilog
            if {$::env(OPTION_CASE) eq "abbreviated_verilog"} {set fmt ver}
            set f [netgen::readnet $fmt input.v]
            netgen::writenet $fmt top $f
            check_output top.v {(?m)^module top }
        }
        readlib_spice {
            set fmt spice
            set f [netgen::readlib $fmt input.spice]
            netgen::writenet $fmt top $f
            check_output top.spice {^SPICE deck for cell top }
        }
        write_then_read {
            set f [netgen::readnet spice input.spice]
            set fmt spice
            netgen::writenet $fmt top $f
            check_output top.spice {^SPICE deck for cell top }
            set second [netgen::readnet $fmt top.spice]
            if {$second < 0} {error "CHECK FAILED: could not read the export"}
        }
        invalid_read_format {
            set f [netgen::readnet spice input.spice]
            set fmt wombat
            netgen::writenet $fmt top $f
            # Wombat is a writer option, not a reader option.
            must_reject [list netgen::readnet $fmt input.spice] {bad format}
        }
        ambiguous_write_format {
            set fmt s
            # 's' is unique in readlib, but ambiguous in writenet.
            set f [netgen::readlib $fmt input.spice]
            must_reject [list netgen::writenet $fmt top $f] {ambiguous format}
        }
        invalid_summary {
            set option resolve
            netgen::run $option
            must_reject [list netgen::summary $option] {bad option}
        }
        invalid_run {
            set option nodes
            netgen::summary $option
            must_reject [list netgen::run $option] {bad option}
        }
        invalid_boolean {
            set option resolve
            netgen::run $option
            must_reject [list netgen::exhaustive $option] {bad option}
        }
        default {error "CHECK FAILED: unknown case $::env(OPTION_CASE)"}
    }
}

if {[catch {check_option} message]} {
    puts stderr "CHECK FAILED: $message"
    exit 1
}
puts "OPTION CHECK PASSED"
