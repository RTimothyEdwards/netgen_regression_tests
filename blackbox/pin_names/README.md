# pin_names

A black box (a subcircuit with no contents in either netlist) can only be
compared by its pins, so its pins must match by name (allowing for case
differences in case-insensitive netlists, array delimiters, a trailing
"!" on global names, and so on).  If they do not, the black box has failed
to match, even if the differently named pins happen to be in the same order
and are wired the same way in the parent cell, because there is no way to
tell whether they correspond.

Here, `blk` has pins `a b` in the layout and `x y` in the schematic, and is
used the same way in `top` in both.  The result must be a pin mismatch for
`blk`, reported as a subcell that failed to match.

Netgen used to remove the pins of the empty cell as "disconnected" and then
loop without end adding proxy pins to its instances, until it ran out of
memory.  It also reported the pin lists of black boxes as equivalent when
their names did not match.  Fixed in netgen 1.5.330.
