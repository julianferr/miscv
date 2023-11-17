`timescale 1 ns / 1 ps

module Control_tb();

// inputs
reg [2:0] opcode;
reg [3:0] func;
reg reset;
reg CLK;
	 
// outputs
wire RegWrite;
wire ALUsrc;
wire [2:0] ALUop;
wire [2:0] RegStore;
wire MemWrite;
wire MemRead;
wire Branch;
wire JumpOut;
	
Control Control_uut(
	.opcode(opcode),
	.func(func),
	.reset(reset),
	.CLK(CLK),
	.RegWrite(RegWrite),
	.ALUsrc(ALUsrc),
	.ALUop(ALUop),
	.RegStore(RegStore),
	.MemWrite(MemWrite),
	.MemRead(MemRead),
	.Branch(Branch),
	.JumpOut(JumpOut)
);
	
// Clockwork
parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin 
  CLK = 0;
  forever begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end

// Testbench logic
initial begin
  
	// Testing initialiation
	$display("Testing initialiation");

	opcode = 0;
	func = 0;
	reset = 0;
	
	#(2*HALF_PERIOD);
			

	
	// Testing R-type
	if(ALUsrc != 1 || RegStore != 1 || RegWrite != 1 || MemRead != 0 || MemWrite != 0 || Branch != 0 || JumpOut != 0) begin
		failures = failures + 1;
		$display("R-Type failure");
	end
	if(func == 0 && ALUop != 1) begin
		failures = failures + 1;
		$display("R-Type add failure");
	end
	func = 1;
	#(2*HALF_PERIOD);
	if(func == 1 && ALUop != 2) begin
		failures = failures + 1;
		$display("R-Type sub failure");
	end
	func = 2;
	#(2*HALF_PERIOD);
	if(func == 2 && ALUop != 3) begin
		failures = failures + 1;
		$display("R-Type or failure");
	end
	func = 3;
	#(2*HALF_PERIOD);
	if(func == 3 && ALUop != 4) begin
		failures = failures + 1;
		$display("R-Type and failure");
	end
	
	#(2*HALF_PERIOD);
	
	opcode = 1;
	func = 0;
	
	#(2*HALF_PERIOD);

	// Testing I-type
	if(ALUsrc != 0 || RegStore != 1 || RegWrite != 1 || MemRead != 0 || MemWrite != 0 || Branch != 0 || JumpOut != 0) begin
		failures = failures + 1;
		$display("I-Type failure");
	end
	if(func == 0 && ALUop != 1) begin
		failures = failures + 1;
		$display("I-Type add failure");
	end
	func = 4;
	#(2*HALF_PERIOD);
	if(func == 4 && ALUop != 5) begin
		failures = failures + 1;
		$display("I-Type sl failure");
	end
	func = 8;
	#(2*HALF_PERIOD);
	if(func == 8 && ALUop != 6) begin
		failures = failures + 1;
		$display("I-Type sr failure ALUop = %d", ALUop);
	end
	func = 12;
	#(2*HALF_PERIOD);
	if(func == 12 && ALUop != 7) begin
		failures = failures + 1;
		$display("I-Type xor failure");
	end
	
	
	#(2*HALF_PERIOD);
	
	opcode = 2;
	
	#(2*HALF_PERIOD);

	// Testing LW
	if(ALUsrc != 0 || RegStore != 0 || RegWrite != 1 || MemRead != 1 || MemWrite != 0 || Branch != 0 || JumpOut != 0 || ALUop != 1) begin
		failures = failures + 1;
		$display("LW failure");
	end
	
	#(2*HALF_PERIOD);
	
	opcode = 3;
	
	#(2*HALF_PERIOD);

	// Testing SW
	if(ALUsrc != 0 || RegStore != 0 || RegWrite != 0 || MemRead != 0 || MemWrite != 1 || Branch != 0 || JumpOut != 0 || ALUop != 1) begin
		failures = failures + 1;
		$display("SW failure");
	end
	
	#(2*HALF_PERIOD);
	
	opcode = 4;
	
	#(2*HALF_PERIOD);

	// Testing Branch
	if(ALUsrc != 0 || RegStore != 0 || RegWrite != 0 || MemRead != 0 || MemWrite != 0 || Branch != 1 || JumpOut != 0 || ALUop != 2) begin
		failures = failures + 1;
		$display("Branch failure");
	end
	
	#(2*HALF_PERIOD);
	
	opcode = 5;
	
	#(2*HALF_PERIOD);

	// Testing Branch 2
	if(ALUsrc != 0 || RegStore != 0 || RegWrite != 0 || MemRead != 0 || MemWrite != 0 || Branch != 1 || JumpOut != 0 || ALUop != 2) begin
		failures = failures + 1;
		$display("Branch 2 failure");
	end
	
	#(2*HALF_PERIOD);
	
	opcode = 6;
	
	#(2*HALF_PERIOD);

	// Testing Jump In
	if(ALUsrc != 0 || RegStore != 2 || RegWrite != 0 || MemRead != 0 || MemWrite != 0 || Branch != 1 || JumpOut != 0 || ALUop != 0) begin
		failures = failures + 1;
		$display("Jump In failure");
	end
	
	#(2*HALF_PERIOD);
	
	opcode = 7;
	
	#(2*HALF_PERIOD);

	// Testing Jump Out
	if(ALUsrc != 0 || RegStore != 0 || RegWrite != 0 || MemRead != 0 || MemWrite != 0 || Branch != 1 || JumpOut != 1 || ALUop != 0) begin
		failures = failures + 1;
		$display("Jump Out failure");
	end

	#(2*HALF_PERIOD);
	
	reset = 1;
	
	#(2*HALF_PERIOD);

	// Testing Reset
	if(ALUsrc != 0 || RegStore != 0 || RegWrite != 0 || MemRead != 0 || MemWrite != 0 || Branch != 0 || JumpOut != 0 || ALUop != 0) begin
		failures = failures + 1;
		$display("Reset failure");
	end
	
	
	$display("TESTS COMPLETE. \n Failures = %d", failures);
	$stop;
end

endmodule
