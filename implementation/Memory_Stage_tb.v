`timescale 1 ns / 1 ps 

module Memory_Stage_tb();
    reg reset;
    reg CLK;
    reg IRegWrite;
    reg [1:0] IRegStore;
    reg MemWrite;
    reg MemRead;
    reg [15:0] IPCP2;
    reg [15:0] IALUResult;
    reg [15:0] thirdArg;
    reg [2:0] rdMem;
    reg [15:0] loadData;
    reg DataInSelect;
    wire ORegWrite;
    wire [1:0] ORegStore;
    wire [15:0] OPCP2;
    wire [15:0] OALUResult;
    wire [15:0] OStoreMem;
    wire [2:0] rdWB;

    Memory_Stage uut (
    .reset(reset),
    .clk(CLK),
    .IRegWrite(IRegWrite),
    .IRegStore(IRegStore),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .IPCP2(IPCP2),
    .IALUResult(IALUResult),
    .thirdArg(thirdArg),
    .rdMem(rdMem),
    .loadData(loadData),
    .DataInSelect(DataInSelect),
    .ORegWrite(ORegWrite),
    .ORegStore(ORegStore),
    .OPCP2(OPCP2),
    .OALUResult(OALUResult),
    .OStoreMem(OStoreMem),
    .rdWB(rdWB)
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
        IRegWrite = 1;
        IRegStore = 1;
        MemWrite = 0;
        MemRead = 1;
        IALUResult = 'h0004;
        thirdArg = 'hAAAA;
        rdMem = 'b101;
        IPCP2 = 'h0011;
        loadData = 'h0011;
        DataInSelect = 1;

        #(2*HALF_PERIOD);

        if(ORegWrite != 0 || ORegStore != 0 || OPCP2 != 0 || OALUResult != 0 || OStoreMem != 0 || rdWB != 0) begin
            $display("Test 1 Error: Reset error");
        end

        reset = 0;
        MemWrite = 1;

        #(2*HALF_PERIOD);
        if(ORegWrite != IRegWrite || ORegStore != IRegStore || OPCP2 != IPCP2 || OALUResult != IALUResult || OStoreMem != thirdArg || rdWB != rdMem) begin
            $display("Test 2 Error: Memory Stage output is wrong");
        end

        DataInSelect = 0;

        #(2*HALF_PERIOD);
        if(ORegWrite != IRegWrite || ORegStore != IRegStore || OPCP2 != IPCP2 || OALUResult != IALUResult || OStoreMem != loadData || rdWB != rdMem) begin
            $display("Test 3 Error: Memory Stage output is wrong");
        end

        $display("Write Stage Test finished");

    end

endmodule