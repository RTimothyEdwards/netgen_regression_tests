// Top level instantiating the CDL cell "mem"
module top (x, d, vdd, vss);
    input [1:0] x;
    inout d;
    inout vdd;
    inout vss;

    mem \u1.mem  (.\VSS! (vss), .\VDD! (vdd), .A({x[1], x[0]}), .D(d));
endmodule
