// Instances made by generate "for" loops, with and without a block label.

module sub2 (input [1:0] A, input B);
endmodule

module top (input [0:3] y, input [3:0] z, input [5:0] w);
    genvar i;
    generate for (i = 0; i < 2; i = i + 1) begin : g
        sub2 u (.A(y[2*i:2*i+1]), .B(z[i]));
    end
    endgenerate

    genvar j;
    generate for (j = 0; j < 3; j = j + 1) begin
        sub2 v (.A(w[2*j+1:2*j]), .B(z[3]));
    end
    endgenerate
endmodule
