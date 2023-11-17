`timescale 1ns / 1ps

module Imm_Gen_tb;

  // Inputs
  reg [15:0] instruction;

  // Outputs
  wire signed [15:0] immediate;

  // Instantiate the unit under test (UUT)
  Imm_Gen uut (
    .instruction(instruction),
    .immediate(immediate)
  );
  integer failures = 0;

  initial begin
    // Test type I
    instruction = 16'b0000001000000001;
    #10;
    if (immediate !== 1) begin
	 $display("Type I positive case failed");
	 failures = failures + 1;
	 end
    #10;
    instruction = 16'b0010000000000001;
    #10;
    if (immediate !== -16) begin
	 $display("Type I negative case failed");
    failures = failures + 1;
	 end
	 #10;

    // Test type M
    instruction = 16'b0000001000000010;
    #10;
    if (immediate !== 1) begin
	 $display("Type M positive case 1 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b1000000000000010;
    #10;
    if (immediate !== -64) begin
	 $display("Type M negative case 1 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b0000001000000011;
    #10;
    if (immediate !== 16'sb0000000000000001) begin 
	 $display("Type M positive case 2 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b1000000000000011;
    #10;
    if (immediate !== 16'sb1111111111000000) begin
	 $display("Type M negative case 2 failed");
    failures = failures + 1;
	 end
	 #10;

    // Test type Y
    instruction = 16'b0000000000001100;
    #10;
    if (immediate !== 16'sb0000000000000010) begin
	 $display("Type Y positive case 1 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b1000000000000100;
    #10;
    if (immediate !== 16'sb1111111110000000) begin
	 $display("Type Y negative case 1 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b0000000000001101;
    #10;
    if (immediate !== 16'sb0000000000000010) begin
	 $display("Type Y positive case 2 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b1000000000000101;
    #10;
    if (immediate !== 16'sb1111111110000000) begin
	 $display("Type Y negative case 2 failed");
    failures = failures + 1;
	 end
	 #10;

    // Test type J
    instruction = 16'b0000000001000110;
    #10;
    if (immediate !== 16'sb0000000000000010) begin
	 $display("Type J positive case 1 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b1000000000000110;
    #10;
    if (immediate !== 16'sb1111110000000000) begin
	 $display("Type J negative case 1 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b0000000001000111;
    #10;
    if (immediate !== 16'sb0000000000000010) begin
	 $display("Type J positive case 2 failed");
    failures = failures + 1;
	 end
	 #10;
    instruction = 16'b1000000000000111;
    #10;
    if (immediate !== 16'sb1111110000000000) begin
	 $display("Type J negative case 2 failed");
    failures = failures + 1;
	 end
	 #10;
	 $display("TESTS COMPLETE. \n Failures = %d", failures);
	$stop;
    // $display("All test cases passed");
  end

endmodule