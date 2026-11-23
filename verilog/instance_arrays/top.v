// Instance arrays connected to buses that run in the same direction as
// the array or in the opposite direction.  The comment on each line
// gives the expected connections.

module top (
    input [5:0] x, input [0:3] y, input [3:0] p, input [3:0] q,
    input [1:0] w, input [1:0] c, input [0:1] d, input s, input b
);
    sub2 u1[1:3] (.A(x), .B(b));	// x[5:4]->u1[1], x[3:2]->u1[2], x[1:0]->u1[3]
    sub2 u2[0:1] (.A(y), .B(b));	// y[0:1]->u2[0], y[2:3]->u2[1]
    sub2 u3[1:0] (.A(p), .B(b));	// p[3:2]->u3[1], p[1:0]->u3[0]
    sub2 u4[1:2] (.A(q), .B(b));	// q[3:2]->u4[1], q[1:0]->u4[2]
    sub2 u5[2:0] (.A(w), .B(b));	// w[1:0] to every instance
    sub1 u6[0:1] (.A(c), .B(b));	// c[1]->u6[0], c[0]->u6[1]
    sub1 u7[1:0] (.A(d), .B(b));	// d[0]->u7[1], d[1]->u7[0]
    sub1 u8[0:1] (.A(s), .B(b));	// s to both instances
    sub1 u9[0:1] (.A(x[3]), .B(b));	// x[3] to both instances
endmodule
