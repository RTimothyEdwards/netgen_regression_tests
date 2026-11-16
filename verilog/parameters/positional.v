// A parameter value given by position (not supported:  must warn)
module chain #(parameter L = 10) (input a, output b, input g);
    wire w;
    res #(.L(L)) r1 (.a(a), .b(w), .g(g));
    res #(.L(L*2)) r2 (.a(w), .b(b), .g(g));
endmodule

module top (input a, output c, input g);
    wire b;
    chain #(3) c1 (.a(a), .b(b), .g(g));
    chain c2 (.a(b), .b(c), .g(g));
endmodule
