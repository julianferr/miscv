// Wrapper module for raw memory
// This Memory represents the text memory.
// Only bits 0-9 can be used.
module Memory_Text
(
	input [15:0] data,
	input [15:0] addr,
	input we, clk,
	output [15:0] q
);

wire[8:0] modified_addr;
assign modified_addr = {1'b0, addr[8:1]};

	raw_memory mem(
		.data(data),
		.addr(modified_addr),
		.we(we),
		.clk(clk),
		.q(q)
	);

endmodule