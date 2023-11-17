`timescale 1 ns / 1 ps

module ID_EX_tb();

  // Define test bench regs for each input from the given module
  reg [0:0] IRegWrite;
  reg [0:0] IALUSrc;
  reg [2:0] IALUOP;
  reg [0:0] IMemWrite;
  reg [0:0] IMemRead;
  reg [0:0] IRegStore;
  reg [15:0] IPCP2;
  reg [15:0] I1stArg;
  reg [15:0] I2ndArg;
  reg [15:0] I3rdArg;
  reg [15:0] IImm;
  reg [15:0] IRs1;
  reg [15:0] IRs2;
  reg [15:0] IRd;
  reg CLK;
  reg Reset;
  reg RegWrite;

  // Define wires for each output from the given module
  wire [0:0] ORegWrite;
  wire [0:0] OALUSrc;
  wire [2:0] OALUOP;
  wire [0:0] OMemWrite;
  wire [0:0] OMemRead;
  wire [0:0] ORegStore;
  wire [15:0] OPCP2;
  wire [15:0] O1stArg;
  wire [15:0] O2ndArg;
  wire [15:0] O3rdArg;
  wire [15:0] OImm;
  wire [15:0] ORs1;
  wire [15:0] ORs2;
  wire [15:0] ORd;

  // Instantiate the module with connections
  ID_EX uut (
    .IRegWrite(IRegWrite),
    .IALUSrc(IALUSrc),
    .IALUOP(IALUOP),
    .IMemWrite(IMemWrite),
    .IMemRead(IMemRead),
    .IRegStore(IRegStore),
    .IPCP2(IPCP2),
    .I1stArg(I1stArg),
    .I2ndArg(I2ndArg),
    .I3rdArg(I3rdArg),
    .IImm(IImm),
    .IRs1(IRs1),
    .IRs2(IRs2),
    .IRd(IRd),
    .CLK(CLK),
    .Reset(Reset),
    .RegWrite(RegWrite),
    .ORegWrite(ORegWrite),
    .OALUSrc(OALUSrc),
    .OALUOP(OALUOP),
    .OMemWrite(OMemWrite),
    .OMemRead(OMemRead),
    .ORegStore(ORegStore),
    .OPCP2(OPCP2),
    .O1stArg(O1stArg),
    .O2ndArg(O2ndArg),
    .O3rdArg(O3rdArg),
    .OImm(OImm),
    .ORs1(ORs1),
    .ORs2(ORs2),
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
    RegWrite = 1;

    // Initialize all regs with corresponding values
    IRegWrite = 1'b1;
    IALUSrc = 1'b1;
    IALUOP = 3'b101;
    IMemWrite = 1'b1;
    IMemRead = 1'b1;
    IRegStore = 1'b1;
    IPCP2 = 16'hA5A5;
    I1stArg = 16'h1234;
    I2ndArg = 16'h5678;
    I3rdArg = 16'h9ABC;
    IImm = 16'hFEDC;
    IRs1 = 16'h2468;
    IRs2 = 16'hBEEF;
    IRd = 16'hC0DE;

    #(2*HALF_PERIOD);

    if (|ORegWrite || |OALUSrc || |OALUOP || |OMemWrite || |OMemRead || |ORegStore || |OPCP2 || |O1stArg || |O2ndArg || |O3rdArg || |OImm || |ORs1 || |ORs2 || |ORd) begin
        $display("Test 1 Error: Reset not working");
    end

    Reset = 0;

    #(2*HALF_PERIOD);

    if (ORegWrite != IRegWrite || OALUSrc != IALUSrc || OALUOP != IALUOP || OMemWrite !== IMemWrite || OMemRead !== IMemRead || ORegStore !== IRegStore || OPCP2 !== IPCP2 || O1stArg !== I1stArg || O2ndArg !== I2ndArg || O3rdArg !== I3rdArg || OImm !== IImm || ORs1 !== IRs1 || ORs2 !== IRs2 || ORd !== IRd) begin
        $display("Test 2 Error: Registers not writing.");
    end


    $display("ID_EX Tests finished");
  end


endmodule
