// A module that netgen can read, instancing black-box modules.

module sub2 (input [1:0] A, input B);
endmodule

module sub1 (input A, input B);
endmodule

module top (input [3:0] x, input [0:1] d, input b);
    sub2 u1[0:1] (.A(x), .B(b));	// x[3:2]->u1[0], x[1:0]->u1[1]
    sub1 u2[1:0] (.A(d), .B(b));	// d[0]->u2[1], d[1]->u2[0]
    sub1 u3 (.A(x[0]), .B(d[0]));
endmodule
