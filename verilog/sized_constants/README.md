# sized_constants

Verilog parameter values written as based constants, such as `32'd10`,
`4'b0011`, or `32'hdead_beef`, are numbers.  This is the form in which
yosys writes parameter values, for example.

The netlists are the same as in `verilog/parameters`:  `top` instances
module `chain` with `L=3` and with its default `L=10`, and `chain` passes
`L` and `L*2` to the SPICE subcircuit `res`, so the four transistors must
have `L` = 3, 6, 10, and 20.  Here the values are based constants in the
module header (`32'd10`), in an instance parameter (`4'b0011`), and in a
`` `define`` used in a `localparam` expression (`8'd2`), and a bus range
is a based constant (`[2'd1:0]`).  A value with `x` bits (`4'bxx01`) is
not a number and is kept as it is given.

The `localparam` expression `L * `TWO` also contains spaces, which
netgen did not accept in a parameter declared in the module body.

Netgen 1.5.330 and earlier did not read these values as numbers, so the
parameters were not resolved (all four transistors were given the default
`L=1` of `res`), and in a bus range read the size as the value (`2'd1` as
2).  Fixed in netgen 1.5.331.
