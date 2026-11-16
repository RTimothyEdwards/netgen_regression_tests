# param_before_definition

A parameter may be used before the `.param` statement that defines it,
both inside a subcircuit (local parameter) and at the top level of the
file (global parameter).

In the schematic, subcircuit `stage` uses `W='space'` on the line before
`.param space=7`, and `top` uses `W='late'` where `.param late=5` is at the
end of the file.

Netgen used to evaluate parameter expressions as each line was read, so
these were left unresolved.  Expressions are now evaluated after the whole
file has been read.  Fixed in netgen 1.5.330.
