`timescale 1 ns / 1 ps 

module Write_Stage_tb();
    reg reset;
    reg CLK;
    reg RegWrite;
    reg [1:0] RegStore;
    reg [15:0] IPCP2;
    reg [15:0] ALUResult;
    reg [15:0] StoreMem;
    reg [2:0] rdWB;
    wire [15:0] loadData;
    wire [2:0] loadAddr;
    wire regWriteOut;

    Write_Stage uut (
        .reset(reset),
        .clk(CLK),
        .RegWrite(RegWrite),
        .RegStore(RegStore),
        .IPCP2(IPCP2),
        .ALUResult(ALUResult),
        .StoreMem(StoreMem),
        .rdWB(rdWB),
        .loadData(loadData),
        .loadAddr(loadAddr),
        .regWriteOut(regWriteOut)
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
        RegWrite = 1;
        RegStore = 1;
        ALUResult = 'hAAAA;
        StoreMem = 'hBBBB;
        IPCP2 = 'hCCCC;
        rdWB = 'b101;

        #(2*HALF_PERIOD);

        if(loadData != 0 || loadAddr != 0 || regWriteOut != 0) begin
            $display("Test 1 Error: Reset error");
        end

        reset = 0;

        #(2*HALF_PERIOD);
        if(loadData != ALUResult || loadAddr != rdWB || regWriteOut != RegWrite) begin
            $display("Test 2 Error: Writeback does not output correctly when RegWrite is 1");
        end

        RegStore = 0;
        #(2*HALF_PERIOD);
        if(loadData != StoreMem || loadAddr != rdWB || regWriteOut != RegWrite) begin
            $display("Test 3 Error: Writeback does not output correctly when RegWrite is 0");
        end

        RegStore = 2;
        #(2*HALF_PERIOD);
        if(loadData != IPCP2 || loadAddr != rdWB || regWriteOut != 1) begin
            $display("Test 4 Error: Writeback does not output correctly when RegWrite is 2");
        end

        $display("Write Stage Test finished");

    end

endmodule