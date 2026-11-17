// "gen" has a generate loop whose bound is a parameter of the module
// header, which netgen cannot evaluate.  It is used by "user" before it
// is defined, and is followed by another module, "after".
module user (input a, output [3:0] b, input g);
    gen #(.N(3)) g1 (.a(a), .b(b), .g(g));
endmodule

module gen #(parameter N = 2) (input a, output [3:0] b, input g);
    genvar i;
    generate for (i = 0; i < N; i = i + 1) begin : loop
	res r (.a(a), .b(b[i]), .g(g));
    end endgenerate
endmodule

module after (input a, output b, input g);
    res r (.a(a), .b(b), .g(g));
endmodule
