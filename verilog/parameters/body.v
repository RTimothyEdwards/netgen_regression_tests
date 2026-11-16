// Parameters declared in the module body;  a localparam derived from a
// parameter;  and parameter values with spaces and parentheses.
module chain (input a, output b, input g);
    parameter L = 10;
    localparam L2 = L*2;
    wire w;
    res #(.L( L )) r1 (.a(a), .b(w), .g(g));
    res #(.L((L2 + 0) * 1)) r2 (.a(w), .b(b), .g(g));
endmodule

module top (input a, output c, input g);
    wire b;
    chain #(.L(3)) c1 (.a(a), .b(b), .g(g));
    chain c2 (.a(b), .b(c), .g(g));
endmodule
