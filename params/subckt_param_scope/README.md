# subckt_param_scope

A parameter declared on a `.subckt` line is local to the subcircuit and
takes precedence over a global `.param` of the same name.

The schematic has a global `.param L=99` and a subcircuit `chain` declaring
`L=12`.  The transistor inside `chain` has `W='L'`, which must be 12 (the
layout value), not 99.  A transistor at the top level with `W='L'` must use
the global value 99.

Netgen used to look up global parameters first, so the transistor in
`chain` got `W=99`.  Fixed in netgen 1.5.330.
