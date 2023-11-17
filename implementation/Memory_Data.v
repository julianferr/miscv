// Wrapper module for raw memory
// This Memory represents the data memory.
// Only bits 0-10 can be used.
module Memory_Data
(
	input [15:0] data,
	input [15:0] addr,
	input [15:0] in,
	input we, clk,
	output [15:0] out,
	output [15:0] q
);

wire[8:0] modified_addr;
assign modified_addr = {1'b1, addr[8:1]};

wire[15:0] mem_in;
wire[15:0] mem_out;

assign mem_in = (addr == 0) ? 0 : data;
assign out = ((addr == 0) && (we == 1)) ? data : 0; // fix

raw_memory mem(
	.data(mem_in),
	.addr(modified_addr),
	.we(we),
	.clk(~clk),
	.q(mem_out)
);

assign q = (addr == 0) ? in : mem_out;

endmodule