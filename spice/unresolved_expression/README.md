# unresolved_expression

When a property is an expression that cannot be resolved (here, because it
uses parameters that are never defined), comparing it must report it as an
unresolved expression, not as a number.

Both netlists are the same:  voltage sources and transistors with values
`{undef}`, `{undef2}`, and `'undef3'`.  The voltage sources are given in
`pulse(...)` form, which also gives them numeric `value` properties, so the
property definition for voltage sources has a numeric type.

Netgen used to compare the two unresolved expressions as numbers, reading
the memory address of the expression as a floating-point value, and
reported errors such as "value circuit1: 4.65e-310 circuit2: 4.65e-310".
Fixed in netgen 1.5.330.
