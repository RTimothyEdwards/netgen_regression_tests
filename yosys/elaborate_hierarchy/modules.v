// The same as design.v, without module "top" (see top.spice).

module child #(parameter W = 1) (input a, output b, input g);
    res #(.L(W)) r (.a(a), .b(b), .g(g));
endmodule

module mid #(parameter N = 2) (input a, output [3:0] b, input g);
    genvar i;
    generate for (i = 0; i < N; i = i + 1) begin : gen
	child #(.W(i + 5)) c (.a(a), .b(b[i]), .g(g));
    end endgenerate
endmodule
