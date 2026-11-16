# elaborate_expressions

During elaboration, a subcircuit's parameter defaults and its local
`.param` values may be expressions in terms of the parameters passed to it
and of global parameters.

In the schematic, `cell` declares `W=1 L='W*2'` and has `.param
w2='W*scale'` (with global `.param scale=2`) and `.param w3={W}`
(evaluated from braces) defined after the transistors that use them.
Instance `X1` passes `W=3` (so `W=6 L=6` for `M1`, and `W=3` for `M2`), and
instance `X2` passes nothing (so the defaults:  `W=2 L=2` and `W=1`).

Netgen used to drop a parameter name that was the last item inside braces,
as in `{W}`, when it could not be resolved immediately.  Fixed, and
elaboration added, in netgen 1.5.330.
