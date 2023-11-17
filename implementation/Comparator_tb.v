module Comparator_tb();

//inputs
reg[15:0] first_input;
reg[15:0] second_input;
reg[2:0] op;
reg[0:0] clock;

//output
wire[0:0] out;

//instantiate any module to test (in this case, the ALU)
Comparator Comparator_uut(
	.FirstInput(first_input),
	.SecondInput(second_input),
	.OPCode(op),
	.CLK(clock),
    .BranchComparison(out)
);

//clockwork
parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
    clock = 0;
    forever begin
        #(HALF_PERIOD);
        clock = ~clock;
    end
end

initial begin
	
 	//-----TEST 1-----
	//Testing branch equal for pass and fail
	#(2*HALF_PERIOD);
	
	
	first_input = 16;
	second_input = 16;
	op = 4;
	
	#(2*HALF_PERIOD);
	if (out != 1) begin
		failures = failures + 1;
		$display("Failure at Y= when rs1 and rs2 are equal");
	end
	
	second_input = 4;
	
	#(2*HALF_PERIOD);
	if (out != 0) begin
		failures = failures + 1;
		$display("Failure at Y= when rs1 and rs2 are not equal");
	end
	
	//-----TEST 2-----
	//Testing branch less than for pass and fail
	
	first_input = 12;
	second_input = 16;
	op = 5;
	#(2*HALF_PERIOD);
	if (out != 1) begin
		failures = failures + 1;
		$display("Failure at Y< when rs1 < rs2");
	end
	
	second_input = 6;
	
	#(2*HALF_PERIOD);
	if (out != 0) begin
		failures = failures + 1;
		$display("Failure at Y= when rs1 !< rs2");
	end
	
	//-----TEST 3-----
	//Testing branch less than for pass and fail
	
	
	op = 6;
	#(2*HALF_PERIOD);
	if (out != 1) begin
		failures = failures + 1;
		$display("Failure at jump");
	end
	
	op = 7;
	
	#(2*HALF_PERIOD);
	if (out != 1) begin
		failures = failures + 1;
		$display("Failure at jump");
	end
	
	$display("TESTS COMPLETE. \n Failures = %d", failures);
	$stop;
	
end
endmodule