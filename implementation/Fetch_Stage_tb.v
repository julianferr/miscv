`timescale 1 ns / 1 ps 

module Fetch_Stage_tb();
    reg reset;
    reg CLK;

    wire [15:0] new_pc;
    wire [15:0] old_pc;
    wire [15:0] ir;

    Fetch_Stage uut (
        .pc_in(new_pc),
        .reset(reset),
        .clk(CLK),
        .new_pc(new_pc),
        .old_pc(old_pc),
        .ir(ir)
    );

    parameter HALF_PERIOD = 50;

    initial begin 
        CLK = 0;
        repeat (20) begin
            #(HALF_PERIOD);
            CLK = ~CLK;
        end
    end

    initial begin
        CLK = 0;
        reset = 1;

        #(2*HALF_PERIOD);

        if(new_pc != 2 || old_pc != 0 || ir != 0) begin
            $display("Test 1: Reset error");
        end

        reset = 0;

        #(2*HALF_PERIOD);



        $display("Fetch Stage Test finished");

    end

endmodule