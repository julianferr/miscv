module Control(
    input [2:0] opcode,
    input [3:0] func,
    input reset,
	input CLK,
    output reg RegWrite,
    output reg ALUsrc,
    output reg [2:0] ALUop,
    output reg MemWrite,
    output reg MemRead,
    output reg [1:0] RegStore,
    output reg Branch,
	output reg JumpOut
);


always @ *
begin

    if(opcode == 0) begin // R-Type
		ALUsrc = 1;
		RegStore = 1;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		JumpOut = 0;
		if(func == 0) begin
			ALUop = 1;
		end
		if(func == 1) begin
			ALUop = 2;
		end
		if(func == 2) begin
			ALUop = 3;
		end
		if(func == 3) begin
			ALUop = 4;
		end
	 end
	 if(opcode == 1) begin // I-Type
		ALUsrc = 0;
		RegStore = 1;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		JumpOut = 0;
		if(func[3:2] == 0) begin
			ALUop = 1;
		end
		if(func[3:2] == 1) begin
			ALUop = 5;
		end
		if(func[3:2] == 2) begin
			ALUop = 6;
		end
		if(func[3:2] == 3) begin
			ALUop = 7;
		end
	 end
	 if(opcode == 2) begin // LW
		ALUsrc = 0;
		RegStore = 0;
		RegWrite = 1;
		MemRead = 1;
		MemWrite = 0;
		Branch = 0;
		JumpOut = 0;
		ALUop = 1;
	 end
	 if(opcode == 3) begin // SW
		ALUsrc = 0;
		RegStore = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 1;
		Branch = 0;
		JumpOut = 0;
		ALUop = 1;
	 end
	 if(opcode == 4 || opcode == 5) begin // Branch
		ALUsrc = 0;
		RegStore = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 1;
		JumpOut = 0;
		ALUop = 2;
	 end
	 if(opcode == 6) begin // Jump in
		ALUsrc = 0;
		RegStore = 2;
		RegWrite = 1	;
		MemRead = 0;
		MemWrite = 0;
		Branch = 1;
		JumpOut = 0;
		ALUop = 0;
	 end
	 if(opcode == 7) begin // Jump out
		ALUsrc = 0;
		RegStore = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 1;
		JumpOut = 1;
		ALUop = 0;
	 end

	 if(reset == 1) begin //Reset
		ALUsrc = 0;
		RegStore = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		JumpOut = 0;
		ALUop = 0;
	end
	 
end

endmodule