module ALU(
	input signed [15:0] FirstInput,
	input signed [15:0] SecondInput,
	input [2:0] ALUOp,
    output reg signed[15:0]OutputData
);

always @ (*)
    begin
        if (ALUOp == 0) begin 
                    OutputData = 0;
        end else if (ALUOp == 1) begin 
            OutputData = SecondInput + FirstInput;
        end else if (ALUOp == 2) begin 
                    OutputData = FirstInput - SecondInput;
        end else if (ALUOp == 3) begin 
                    OutputData = FirstInput | SecondInput;
        end else if (ALUOp == 4) begin 
                    OutputData = FirstInput & SecondInput;
        end else if (ALUOp == 5) begin 
                    OutputData = FirstInput << SecondInput;
        end else if (ALUOp == 6) begin 
                    OutputData = FirstInput >> SecondInput;
        end else if (ALUOp == 7) begin 
                    OutputData = (FirstInput | SecondInput) & ~(FirstInput & SecondInput);
        end 
    end
endmodule