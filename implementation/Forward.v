module Forward(
	input [2:0] rs1EX,
	input [2:0] rs2EX,
	input [2:0] rdEX,
	input [2:0] rdMEM,
	input [2:0] rdWB,
	input [2:0] rs1,
	input [2:0] rs2,
	input RegWriteMEM,
	input RegWriteWB,
	output reg [1:0] fwd1EX,
	output reg [1:0] fwd2EX,
	output reg [0:0] fwd3EX,
	output reg [1:0] Bfwd1,
	output reg [1:0] Bfwd2,
	output reg [0:0] fwdMEM
);

	always @(*) begin
		//Default Values
		fwd1EX = 2;
		fwd2EX = 2;
		fwd3EX = 1;
		fwdMEM = 1;
		Bfwd1 = 2;
		Bfwd2 = 2;
		
		
		if (rs1EX == rdMEM && RegWriteMEM == 1 && rs1EX != 0) begin
			fwd1EX = 0;
		end
		if (rs2EX == rdMEM && RegWriteMEM == 1 && rs2EX != 0) begin
			fwd2EX = 0;
		end
		if (rdEX == rdWB && RegWriteWB == 1 && rdEX != 0) begin
			fwd3EX = 0;
		end
		if (rdMEM == rdWB && RegWriteWB == 1 && rdMEM != 0) begin
			fwdMEM = 0;
		end
		if (rs1EX == rdWB && rs1EX != rdMEM && RegWriteWB == 1 && rs1EX != 0) begin
			fwd1EX = 1;
		end
		if (rs2EX == rdWB && rs2EX != rdMEM && RegWriteWB == 1 && rs2EX != 0) begin
			fwd2EX = 1;
		end
		if (rs1 == rdMEM && rs1 != 0 && RegWriteMEM == 1) begin
			Bfwd1 = 0;
		end
		if (rs2 == rdMEM && RegWriteMEM == 1 && rs2 != 0) begin
			Bfwd2 = 0;
		end
		if (rs1 == rdWB && RegWriteWB == 1 && rs1 != 0) begin
			Bfwd1 = 1;
		end
		if (rs2 == rdWB && RegWriteWB == 1 && rs2 != 0) begin
			Bfwd2 = 1;
		end
		
	end
endmodule
