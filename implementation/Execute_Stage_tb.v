`timescale 1 ns / 1 ps

module Execute_Stage_tb();

    // Define test bench inputs as regs
    reg IRegWrite;
    reg IALUSrc;
    reg [2:0] IALUOp;
    reg IMemWrite;
    reg IMemRead;
    reg [1:0] IRegStore;
    reg [15:0] IPCP2;
    reg [15:0] I1stArg;
    reg [15:0] I2ndArg;
    reg [15:0] I3rdArg;
    reg [15:0] Imm;
    reg [2:0] IRs1;
    reg [2:0] IRs2;
    reg [2:0] IRd;
    reg [15:0] ALUResultMEM;
    reg [15:0] loadDataWB;
    reg [1:0] muxFwd1select;
    reg [1:0] muxFwd2select;
    reg [0:0] muxFwd3select;
    reg reset;
    reg clk;

    // Define test bench outputs as wires
    wire ORegWrite;
    wire OMemWrite;
    wire OMemRead;
    wire [1:0] ORegStore;
    wire [15:0] OPCP2;
    wire [15:0] OALUResult;
    wire [15:0] O3rdArg;
    wire [2:0] ORs1;
    wire [2:0] ORs2;
    wire [2:0] ORd;

    // Instantiate the module under test
    Execute_Stage UUT (
        .IRegWrite(IRegWrite),
        .IALUSrc(IALUSrc),
        .IALUOp(IALUOp),
        .IMemWrite(IMemWrite),
        .IMemRead(IMemRead),
        .IRegStore(IRegStore),
        .IPCP2(IPCP2),
        .I1stArg(I1stArg),
        .I2ndArg(I2ndArg),
        .I3rdArg(I3rdArg),
        .Imm(Imm),
        .IRs1(IRs1),
        .IRs2(IRs2),
        .IRd(IRd),
        .ALUResultMEM(ALUResultMEM),
        .loadDataWB(loadDataWB),
        .muxFwd1select(muxFwd1select),
        .muxFwd2select(muxFwd2select),
        .muxFwd3select(muxFwd3select),
        .reset(reset),
        .clk(clk),
        .ORegWrite(ORegWrite),
        .ORegStore(ORegStore),
        .OMemWrite(OMemWrite),
        .OMemRead(OMemRead),
        .OPCP2(OPCP2),
        .OALUResult(OALUResult),
        .O3rdArg(O3rdArg),
        .ORs1(ORs1),
        .ORs2(ORs2),
        .ORd(ORd)
    );

    parameter HALF_PERIOD = 50;

initial begin 
  clk = 0;
  forever begin
        #(HALF_PERIOD);
        clk = ~clk;
    end
end

    initial begin

        $display("Testing Initialization");
        clk = 0;
        // Initialize all regs with non-zero values
        IRegWrite = 1;
        IALUSrc = 1;
        IALUOp = 0;
        IMemWrite = 0;
        IMemRead = 1;
        IRegStore = 1;
        IPCP2 = 16'hA5A5;
        I1stArg = 12;
        I2ndArg = 2;
        I3rdArg = 16'h9ABC;
        Imm = 10;
        IRs1 = 5;
        IRs2 = 6;
        IRd = 3;
        ALUResultMEM = 16'h9ABC;
        loadDataWB = 16'hDEAD;
        muxFwd1select = 2;
        muxFwd2select = 2;
        muxFwd3select = 1;

        reset = 0;

        #(2*HALF_PERIOD);

        // Testing No-op values
        if (ORegWrite != 1) begin
            $display("ORegWrite fails");
        end

        if (OMemWrite != 0) begin
            $display("OMemWrite fails");
        end

        if (OMemRead != 1) begin
            $display("OMemRead fails");
        end

        if (ORegStore != 1) begin
            $display("ORegStore fails");
        end

        if (OPCP2 != 16'hA5A5) begin
            $display("OPCP2 fails");
        end

        if (OALUResult != 0) begin
            $display("OALUResult fails");
        end

        if (O3rdArg != 16'h9ABC) begin
            $display("O3rdArg fails");
        end

        if (ORs1 != 5) begin
            $display("ORs1 fails");
        end

        if (ORs2 != 6) begin
            $display("ORs2 fails");
        end

        if (ORd != 3) begin
            $display("ORd fails");
        end


        //Testing R-types
        IALUOp = 1;
        #(2*HALF_PERIOD);
        // Testing add
        if (OALUResult != 14) begin
            $display("Add fails. Result: %d", OALUResult);
        end

        IALUOp = 2;
        #(2*HALF_PERIOD);
        // Testing sub
        if (OALUResult != 10) begin
            $display("Sub fails. Result: %d", OALUResult);
        end

        //Testing I-types
        IALUSrc = 0;
        IALUOp = 1;
        #(2*HALF_PERIOD);
        // Testing add
        if (OALUResult != 22) begin
            $display("I-type add fails. Result: %d", OALUResult);
        end

        IALUOp = 5;
        #(2*HALF_PERIOD);
        // Testing sub
        if (OALUResult != 12288) begin
            $display("Shift Left fails. Result: %d", OALUResult);
        end


        reset = 1;
        #(2*HALF_PERIOD);

        // Testing Reset
        if(ORegWrite != 0 ||
            OMemWrite != 0 ||
            OMemRead != 0 ||
            ORegStore != 0 ||
            OPCP2 != 0 ||
            OALUResult != 0 ||
            O3rdArg != 0 ||
            ORs1 != 0 ||
            ORs2 != 0 ||
            ORd != 0) begin
            $display("Reset fail");
        end

        $display("Execute_Stage Tests finished");
        $stop;
    end

endmodule
