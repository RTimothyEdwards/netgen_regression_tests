// Wire bundles connected to instances and arrays of instances.  The
// comment on each line gives the expected connections.

module top (
    input [3:0] x, input [0:1] c, input [1:0] w, input a, input s, input b
);
    sub1 u1[0:3] (.A({a, s, x[3], c[0]}), .B(b));  // a->u1[0], s->u1[1], x[3]->u1[2], c[0]->u1[3]
    sub1 u2[3:0] (.A({x[1:0], c}), .B(b));	// x[1]->u2[3], x[0]->u2[2], c[0]->u2[1], c[1]->u2[0]
    sub2 u3[1:0] (.A({a, x[2:1], s}), .B(b));	// a,x[2]->u3[1], x[1],s->u3[0]
    sub2 u4[0:2] (.A({s, a}), .B(b));		// s,a to every instance
    sub2 u5 (.A({a, s}), .B(b));		// a,s
    sub3 u6 (.A({w, a}), .B(b));		// w[1],w[0],a
    sub1 u7 (.A({s}), .B(b));			// s
endmodule
