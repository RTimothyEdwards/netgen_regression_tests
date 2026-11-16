# elaborate_variants

When the instances of a subcircuit pass it different sets of parameter
values, a copy of the subcircuit is made for each set, named `<name>@1`,
`<name>@2`, etc., and the copies are listed in the output with their
parameter values.  The copies have no match in the layout, so they are
flattened, and the layout's cell of the same name is also flattened.

In the schematic, `cell` (default `W=1`) is instanced with `W=2` twice and
`W=3` once.  The layout has a cell named `cell` (with `W=2`) used once, and
a flat transistor with `W=3`.

The original `cell` in the schematic is no longer used after the copies are
made, so it must not be compared against the layout's `cell`.

Elaboration was added in netgen 1.5.330.
