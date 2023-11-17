`timescale 1 ns / 1 ps

module EX_MEM_tb();

  reg [0:0] IRegWrite;
  reg [0:0] IMemWrite;
  reg [0:0] IMemRead;
  reg [0:0] IRegStore;
  reg [15:0] IPCP2;
  reg [15:0] IALUResult;
  reg [15:0] I3rdArg;
  reg [15:0] IRd;
  reg CLK;
  reg Reset;
  reg RegWrite;
  wire [0:0] ORegWrite;
  wire [0:0] OMemWrite;
  wire [0:0] OMemRead;
  wire [0:0] ORegStore;
  wire [15:0] OPCP2;
  wire [15:0] OALUResult;
  wire [15:0] O3rdArg;
  wire [15:0] ORd;

  EX_MEM uut (
    .IRegWrite(IRegWrite),
    .IMemWrite(IMemWrite),
    .IMemRead(IMemRead),
    .IRegStore(IRegStore),
    .IPCP2(IPCP2),
    .IALUResult(IALUResult),
    .I3rdArg(I3rdArg),
    .IRd(IRd),
    .CLK(CLK),
    .Reset(Reset),
    .RegWrite(RegWrite),
    .ORegWrite(ORegWrite),
    .OMemWrite(OMemWrite),
    .OMemRead(OMemRead),
    .ORegStore(ORegStore),
    .OPCP2(OPCP2),
    .OALUResult(OALUResult),
    .O3rdArg(O3rdArg),
    .ORd(ORd)
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
    Reset = 1;
    RegWrite = 1'b1;
    // Initialize all regs with some non-zero value
    IRegWrite = 1'b0;
    IMemWrite = 1'b0;
    IMemRead = 1'b0;
    IRegStore = 1'b0;
    IPCP2 = 16'h0000;
    IALUResult = 16'h1234;
    I3rdArg = 16'h5678;
    IRd = 16'h9ABC;

    #(2*HALF_PERIOD);

    if (|ORegWrite || |OMemWrite || |OMemRead || |ORegStore || |OPCP2 || |OALUResult || |O3rdArg || |ORd) begin
        $display("Test 1 Error: Reset not working");
    end

    Reset = 0;

    #(2*HALF_PERIOD);

    if (ORegWrite != IRegWrite || OMemWrite !== IMemWrite || OMemRead !== IMemRead || ORegStore !== IRegStore || OPCP2 !== IPCP2 || OALUResult !== IALUResult || O3rdArg !== I3rdArg || ORd !== IRd) begin
        $display("Test 2 Error: Registers not writing.");
    end

    $display("EX_MEM Tests finished");

    end


endmodule
