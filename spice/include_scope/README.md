# include_scope

A SPICE file read with `.include` is read as part of the file that
includes it, at the point where it is included.

1. `subckt_include.spice` includes `subckt_part.spice` from inside a
   `.subckt` definition.  The included file has a transistor and a
   `.param w2=3`.  The transistor must be part of the subcircuit;  the
   transistor after the `.include` must also still be part of the
   subcircuit;  and `w2` must be local to the subcircuit (not the global
   `.param w2=99`).
2. `top_include.spice` has top-level transistors before and after an
   `.include` of a library file that defines a subcircuit.  All of them
   must be part of the top-level cell.

Netgen used to close the subcircuit (or the top-level cell) at the end of
the included file, so the rest of the subcircuit was lost (case 1), or the
top-level cell was started over and the devices before the `.include` were
lost (case 2).  Fixed in netgen 1.5.330.
