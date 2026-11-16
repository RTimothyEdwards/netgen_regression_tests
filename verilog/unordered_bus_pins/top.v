// Top level connecting a bus to cell "fab"
module top (n, q);
    input [11:0] n;
    output q;

    fab u1 (.D({n[11], n[10], n[9], n[8], n[7], n[6],
                n[5], n[4], n[3], n[2], n[1], n[0]}), .Q(q));
endmodule
