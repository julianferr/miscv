`timescale 1 ns / 1 ps 

module Memory_tb();

reg [15:0] data;
reg [15:0] addr;
reg we;
reg [0:0] clk;

wire[15:0] q_text;
wire[15:0] q_data;

Memory_Text text_uut(
	.data(data),
	.addr(addr),
	.we(we),
	.clk(clk),
	.q(q_text)
);

Memory_Data data_uut(
	.data(data),
	.addr(addr),
	.we(we),
	.clk(clk),
	.q(q_data)
);

parameter PERIOD = 50;

initial begin 
	  clk = 0;
	  repeat (50) begin
			#PERIOD;
			clk = ~clk;
	  end
 end
 
 initial begin
	clk = 0;
	we = 1;
	addr = 'h0000;
	data = 'h1111;
	
	#(2*PERIOD);

	if (q_text != data) begin
		$display("Test 1 failed - No Data Write when bit 1");
	end

	addr = 'h0001;
	if (q_data != data) begin
		$display("Test 1 failed - Data  Memory lower bound error");
	end

	we = 0;
	addr = 'h0002;
	data = 'h2222;

	#(2*PERIOD);
	if (q_text == data) begin
		$display("Test 2 failed - Data Write even when bit 0");
	end

	we = 1;
	data = 'h3333;
	#(2*PERIOD);

	if (q_text != data) begin
		$display("Test 3 failed - Data Read even when bit 0");
	end

	addr = 'h03FF;
	data = 'h4444;
	#(2*PERIOD);

	addr = 'hFFFF;
	if (q_text != data) begin
		$display("Test 4 failed - Text Memory upper bound error");
	end
	if (q_data != data) begin
		$display("Test 4 failed - Data Memory upper bound error");
	end

	$display("Mem Tests complete");
	$stop;
end
	  
	  
endmodule