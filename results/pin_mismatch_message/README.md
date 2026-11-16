# pin_mismatch_message

When the netlists of the top cell match but their pins do not, the final
result must say "Top level cell failed pin matching."

The layout and schematic are the same inverter, but the output port is
named `out` in the layout and `z` in the schematic.

This is the counterpart of `net_mismatch_message`, checking that the fix
for that test did not change the report for a real pin mismatch.
