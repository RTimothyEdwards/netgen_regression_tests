# elaborate_flatten

A `flatten` command that names a subcircuit which elaboration has replaced
with copies (one for each unique set of parameters) also applies to the
copies.

In the schematic, `cell` is instanced with two sets of parameters, so it is
copied to `cell@1` and `cell@2`.  The script runs `flatten class top
"<schematic> cell"` before `lvs`, as a setup file might.  This must flatten
the instances of the copies in `top`.

Without this, the command found no instances of `cell` and failed with
"No instances found to flatten."  Fixed in netgen 1.5.330.
