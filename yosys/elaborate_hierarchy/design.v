// "mid" has a generate loop whose bound is its parameter N, which netgen
// cannot evaluate, and passes a different value of W (i + 5) to each
// instance of "child", which netgen can read.  "child" passes W to the
// SPICE subcircuit "res" as its parameter L.  "top" uses mid with N = 3,
// so there must be three transistors, with L = 5, 6, and 7.

module child #(parameter W = 1) (input a, output b, input g);
    res #(.L(W)) r (.a(a), .b(b), .g(g));
endmodule

module mid #(parameter N = 2) (input a, output [3:0] b, input g);
    genvar i;
    generate for (i = 0; i < N; i = i + 1) begin : gen
	child #(.W(i + 5)) c (.a(a), .b(b[i]), .g(g));
    end endgenerate
endmodule

module top (input a, output [3:0] b, input g);
    mid #(.N(3)) m1 (.a(a), .b(b), .g(g));
endmodule
