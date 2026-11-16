# param_expression

The value of a `.param` may be an expression in terms of other parameters.
The expression is evaluated in the scope where the parameter is defined.

- Global:  `.param a=2 b='3*a'`, and a transistor with `W='b'` (6).
- Local:  subcircuit `stage` declares `L=4` on the `.subckt` line and has
  `.param w2='L*2'`;  its transistor has `W='w2'` (8, using the local `L`
  and not the global `.param L=100`).
- A global parameter defined in terms of another global (`.param
  vref='vdd'`) after a subcircuit redefines `vdd` locally must use the
  global `vdd` (1.8).

A second netlist, `circular.spice`, defines `.param x='y' y='x'`.  Netgen
must report the circular definition (once) and finish, not loop forever.

Netgen used to accept only plain numbers as `.param` values.  Fixed in
netgen 1.5.330.
