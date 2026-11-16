# parameters

Parameters passed to verilog module instances (`#(.name(value))`) are
resolved through the hierarchy by elaboration, the same as parameters passed
to SPICE subcircuits.

In each case, `top` instances module `chain` with `L=3` and with its
default `L=10`, and `chain` passes `L` and `L*2` to the SPICE subcircuit
`res`, so the four transistors must have `L` = 3, 6, 10, and 20.

- `header.v`:  the parameter is declared in the module header
  (`module chain #(parameter L = 10) (...)`).
- `body.v`:  the parameter is declared in the module body (`parameter L =
  10;`), with a `localparam` derived from it, and parameter values that
  contain spaces and parentheses.
- `positional.v`:  `top` gives the value by position (`chain #(3) c1`),
  which is not supported;  netgen must say so instead of silently ignoring
  it.

Netgen used to ignore parameters declared in a module body (warning that
the parameter passed to the module has no default), did not accept
parameter values containing spaces, and silently ignored values given by
position.  Fixed in netgen 1.5.330.
