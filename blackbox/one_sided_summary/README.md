# one_sided_summary

When a subcircuit has contents in one netlist but is empty (or not defined)
in the other, netgen treats it as a black box and its contents are not
compared.  The output must list these cells, for each netlist, in a summary
just before the "Final result" line.

- `blk1` is empty in the layout and has a transistor in the schematic.
- `blk2` has a transistor in the layout and is empty in the schematic.
- `blk3` is empty in both, so it must not be listed.

The summary was added in netgen 1.5.329.
