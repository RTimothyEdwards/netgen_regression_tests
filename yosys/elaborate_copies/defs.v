// Read before chip.v (into the same netlist), so that netgen reads the
// module ports in "`ifdef USE_POWER_PINS" (and so does yosys).
`define USE_POWER_PINS
