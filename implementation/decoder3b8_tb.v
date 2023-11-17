`timescale 1 ns / 1 ps 

module decoder3x8_tb();
    reg [2:0] in;


    wire [7:0] out;

    decoder3b8 UUT (
    .in(in),
    .out(out)
    );

    parameter HALF_PERIOD = 50;
    reg CLK;
    initial begin 
        CLK = 0;
        repeat (100) begin
            #(HALF_PERIOD);
            CLK = ~CLK;
        end
    end

    // Test stimulus
    initial begin
    $display("Testing 3x8 Decoder");

    // Case 1: in = 000
    in = 3'b000;
    #1;
    $display("Input: 000, Output: %b", out);
    #(HALF_PERIOD);

    // Case 2: in = 001
    in = 3'b001;
    #1;
    $display("Input: 001, Output: %b", out);
    #(HALF_PERIOD);

    // Case 3: in = 010
    in = 3'b010;
    #1;
    $display("Input: 010, Output: %b", out);
    #(HALF_PERIOD);

    // Case 4: in = 011
    in = 3'b011;
    #1;
    $display("Input: 011, Output: %b", out);
    #(HALF_PERIOD);

    // Case 5: in = 100
    in = 3'b100;
    #1;
    $display("Input: 100, Output: %b", out);
    #(HALF_PERIOD);

    // Case 6: in = 101
    in = 3'b101;
    #1;
    $display("Input: 101, Output: %b", out);
    #(HALF_PERIOD);

    // Case 7: in = 110
    in = 3'b110;
    #1;
    $display("Input: 110, Output: %b", out);
    #(HALF_PERIOD);

    // Case 8: in = 111
    in = 3'b111;
    #1;
    $display("Input: 111, Output: %b", out);
    #(HALF_PERIOD);

    end

endmodule