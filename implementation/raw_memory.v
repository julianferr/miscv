module raw_memory
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=9)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input we, clk,
	output [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];

	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;

	initial begin 
		$readmemh("C:/Users/ferrerj/rhit-csse232-2324a-project-misc-v-2324a/implementation/memory.txt", ram);
		$display("Memory Loaded");
	end
	
	always @ (posedge clk)
	begin
		// Write
		if (we)
			ram[addr] <= data;

		addr_reg <= addr;
	end
 
	assign q = ram[addr_reg];

endmodule