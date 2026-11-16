# elaborate_standalone

A subcircuit that is copied by elaboration (because its instances pass it
different parameters) can still be compared on its own, for example to run
LVS on one block of a design.  The original subcircuit is then compared,
with its default parameter values.

The schematic's `top` instances `cell` with `W=2` and `W=3`, which makes
copies of `cell`.  LVS is run on `cell` alone against a layout `cell` with
`W=1` (the default).

Elaboration was added in netgen 1.5.330.
