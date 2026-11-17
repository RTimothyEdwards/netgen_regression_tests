// An 8-bit identification value made by connecting each output bit to
// either a tie-high or a tie-low cell, chosen by the parameter ID.  The
// cells not chosen are left unconnected (but must still be present).
module id_prog #(
    parameter ID = 8'h0f
) (
`ifdef USE_POWER_PINS
    inout VDD,
    inout VSS,
`endif
    output wire [7:0] id
);
    wire [7:0] high;
    wire [7:0] low;

    tieh one [7:0] (
`ifdef USE_POWER_PINS
	.VDD(VDD), .VSS(VSS),
`endif
	.H(high)
    );
    tiel zero [7:0] (
`ifdef USE_POWER_PINS
	.VDD(VDD), .VSS(VSS),
`endif
	.L(low)
    );

    genvar i;
    generate
	for (i = 0; i < 8; i = i + 1) begin
	    assign id[i] = (ID & (8'h01 << i)) ? high[i] : low[i];
	end
    endgenerate

`ifdef LVS
    decap fill [1:0] (
`ifdef USE_POWER_PINS
	.VDD(VDD), .VSS(VSS)
`endif
    );
`endif
endmodule
