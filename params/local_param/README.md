# local_param

A `.param` statement inside a `.subckt` definition is local to that
subcircuit.  It takes precedence over a global parameter of the same name,
and it does not change the global value.

The schematic has a global `.param vdd=1.8`.  Subcircuit `stage` redefines
`.param vdd=3.3` and has a transistor with `W='vdd'` (must be 3.3).  A
transistor at the top level after the subcircuit definition has `W='vdd'`
and must use the global value 1.8.

Netgen used to put all `.param` values in a single global table, so the
local value replaced the global one for the rest of the file (and in other
cases, unresolved values led to reading invalid memory).  Fixed in netgen
1.5.330.
