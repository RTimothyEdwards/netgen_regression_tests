# elaborate_nested

Parameters can be passed through more than one level of subcircuits, with
expressions at each level.

In the schematic, `top` instances `mid` with `S=1` and `S=2`;  `mid`
instances `inner` with `W='S*2'` and `W='S*3'`;  and `inner` has a
transistor with `W='W'`.  The four transistors must have `W` = 2, 3, 4,
and 6.  This needs two copies of `mid` and four copies of `inner`.

Elaboration was added in netgen 1.5.330.
