# net_mismatch_message

When the top cell fails to match because the netlists differ, the final
result must say "Netlists do not match", not "Top level cell failed pin
matching" (which is only for netlists that match but whose pins do not).
"equate classes" must also not be run on the top cell, so the output must
not claim that the top cells are equivalent.

In the schematic, the gates of `M2` and `M3` are both connected to `x2`,
while in the layout `M3` has its own input `x3`.  Netgen used to report
"Final result: Top level cell failed pin matching."  Fixed in netgen
1.5.329.

See also `pin_mismatch_message`.
