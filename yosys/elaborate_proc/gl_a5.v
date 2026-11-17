// Gate-level id_prog with ID = 8'ha5 (bits 0, 2, 5, 7 high)
module id_prog (inout VDD, inout VSS, output [7:0] id);
    wire [7:0] high;
    wire [7:0] low;
    tieh one [7:0] (.VDD(VDD), .VSS(VSS), .H(high));
    tiel zero [7:0] (.VDD(VDD), .VSS(VSS), .L(low));
    decap fill [1:0] (.VDD(VDD), .VSS(VSS));
    assign id[0] = high[0];
    assign id[1] = low[1];
    assign id[2] = high[2];
    assign id[3] = low[3];
    assign id[4] = low[4];
    assign id[5] = high[5];
    assign id[6] = low[6];
    assign id[7] = high[7];
endmodule
