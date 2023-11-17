module Comparator(
	input [15:0] FirstInput,
	input [15:0] SecondInput,
   	input [0:0] CLK,
	input [2:0] OPCode,
   	output reg [0:0]BranchComparison
);

always @ (*)
begin
	if (OPCode > 5) begin
		BranchComparison = 1;
	end
	else begin
		if (OPCode[0] == 0) begin
			if (FirstInput == SecondInput) begin 
			BranchComparison = 1;
			end
			else BranchComparison = 0;
		end
		else begin
			if (FirstInput < SecondInput) begin
				BranchComparison = 1;
			end
			else BranchComparison = 0;
		end
	end
end
endmodule