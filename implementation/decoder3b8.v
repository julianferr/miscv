module decoder3b8(
    input [2:0] in,
    output [7:0] out
);

assign out[0] = (in == 3'b000) ? 1 : 0;
assign out[1] = (in == 3'b001) ? 1 : 0;
assign out[2] = (in == 3'b010) ? 1 : 0;
assign out[3] = (in == 3'b011) ? 1 : 0;
assign out[4] = (in == 3'b100) ? 1 : 0;
assign out[5] = (in == 3'b101) ? 1 : 0;
assign out[6] = (in == 3'b110) ? 1 : 0;
assign out[7] = (in == 3'b111) ? 1 : 0;

endmodule