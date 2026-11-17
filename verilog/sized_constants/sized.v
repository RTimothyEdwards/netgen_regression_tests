// Parameter values given as verilog based constants (e.g., 32'd10)
`define TWO 8'd2

module chain #(parameter L = 32'd10, parameter ID = 32'hdead_beef)
		(input a, output b, input g);
    parameter X = 4'bxx01;	// x bits:  not a number, kept as given
    localparam L2 = L * `TWO;
    wire [2'd1:0] w;
    res #(.L(L)) r1 (.a(a), .b(w[0]), .g(g));
    res #(.L(L2)) r2 (.a(w[0]), .b(b), .g(g));
endmodule

module top (input a, output c, input g);
    wire b;
    chain #(.L(4'b0011)) c1 (.a(a), .b(b), .g(g));
    chain c2 (.a(b), .b(c), .g(g));
endmodule
