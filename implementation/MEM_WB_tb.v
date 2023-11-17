`timescale 1 ns / 1 ps

module MEM_WB_tb();

  reg [0:0] IRegWrite;
  reg [0:0] IRegStore;
  reg [15:0] IPCP2;
  reg [15:0] IALUResult;
  reg [15:0] IStoreMem;
  reg [2:0] IRd;
  reg CLK;
  reg Reset;
  reg RegWrite;
  
  wire [0:0] ORegWrite;
  wire [0:0] ORegStore;
  wire [15:0] OPCP2;
  wire [15:0] OALUResult;
  wire [15:0] OStoreMem;
  wire [2:0] ORd;

  MEM_WB uut (
    .IRegWrite(IRegWrite),
    .IRegStore(IRegStore),
    .IPCP2(IPCP2),
    .IALUResult(IALUResult),
    .IStoreMem(IStoreMem),
    .IRd(IRd),
    .CLK(CLK),
    .Reset(Reset),
    .RegWrite(RegWrite),
    .ORegWrite(ORegWrite),
    .ORegStore(ORegStore),
    .OPCP2(OPCP2),
    .OALUResult(OALUResult),
    .OStoreMem(OStoreMem),
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
    // Initialize all regs with some non-zero values
    IRegWrite = 1'b1;
    IRegStore = 1'b0;
    IPCP2 = 16'h1234;
    IALUResult = 16'h5678;
    IStoreMem = 16'h9abc;
    IRd = 3'b011;

    #(2*HALF_PERIOD);

    if (|ORegWrite || |ORegStore || |OPCP2 || |OALUResult || |OStoreMem || |ORd) begin
        $display("Test 1 Error: Reset not working");
    end

    Reset = 0;

    #(2*HALF_PERIOD);

    if (ORegWrite != IRegWrite || ORegStore !== IRegStore || OPCP2 !== IPCP2 || OALUResult !== IALUResult || OStoreMem !== IStoreMem || ORd !== IRd) begin
        $display("Test 2 Error: Registers not writing.");
    end

    $display("MEM_WB Tests finished");
  end

endmodule
