`timescale 1 ns / 1 ps

module Register_File_tb();

    // Declare signals for the Register_File inputs and outputs
    reg [2:0] Reg_address1;
    reg [2:0] Reg_address2;
    reg [2:0] Reg_address3;
    reg [2:0] Reg_input_address;
    reg [15:0] Reg_input_data;
    reg CLK;
    reg Reset;
    reg Reg_Write;

    wire [15:0] Reg_output1;
    wire [15:0] Reg_output2;
    wire [15:0] Reg_output3;

    // Instantiate the Register_File module
    Register_File UUT (
        .Reg_address1(Reg_address1),
        .Reg_address2(Reg_address2),
        .Reg_address3(Reg_address3),
        .Reg_input_address(Reg_input_address),
        .Reg_input_data(Reg_input_data),
        .CLK(CLK),
        .Reset(Reset),
        .Reg_Write(Reg_Write),
        .Reg_output1(Reg_output1),
        .Reg_output2(Reg_output2),
        .Reg_output3(Reg_output3)
    );

    parameter HALF_PERIOD = 50;

    initial begin 
        CLK = 0;
        repeat (20) begin
            #(HALF_PERIOD);
            CLK = ~CLK;
        end
    end

    // Testbench logic
    initial begin
        CLK = 0;
        Reset = 1;
        Reg_Write = 0;
        
        #(3*HALF_PERIOD);

        if(Reg_output1 != 0 || Reg_output2 != 0 || Reg_output3 != 0 ) begin
            $display("Test 1 Error: Reset not working");
        end
        Reset = 0; 
        Reg_Write = 1;
        Reg_address1 = 3'b001;
        Reg_address2 = 3'b010;
        Reg_address3 = 3'b011;
        Reg_input_address = 3'b001;
        Reg_input_data = 'h1234;

        #(2*HALF_PERIOD);

        if(Reg_output1 != Reg_input_data || Reg_output2 != 0 || Reg_output3 != 0) begin
            $display("Test 2 Error: Write not working");
        end

        Reg_Write = 0;
        Reg_input_data = 'hFFFF;

        #(2*HALF_PERIOD);

        if(Reg_output1 == Reg_input_data) begin
            $display("Test 3 Error: Writing even with bit 0");
        end

    $display("Register File Tests finished");

    end

endmodule
