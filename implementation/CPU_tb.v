`timescale 1 ns / 1 ps

module CPU_tb();

  // Inputs
  reg clk;
  reg reset;
  reg [15:0] in;
  wire [15:0] out;
//  wire [15:0] OFnewPCCon;
//  wire [15:0] OFPCCon;
//  wire [15:0] OirCon;
//  wire OjumpCon;
//  wire [15:0] OnewPCInCon;
//  wire [2:0] OloadAddrWB;
//  wire [15:0] OloadDataWB;
//  wire OrfWriteWBCon;
//  wire ORegWriteWB;
//  wire OORegWriteEX;
//  wire [1:0] OORegStoreEX;
//  wire OOMemWriteEX;
//  wire OOMemReadEX;
//  wire [15:0] OOPCP2EX;
//  wire [15:0] OOALUResultEX;
//  wire [15:0] OO3rdArgEX;
//  wire [2:0] OORs1EX;
//  wire [2:0] OORs2EX;
//  wire [2:0] OORdEX;
//  wire OORegWriteMEM;
//  wire [1:0] OORegStoreMEM;
//  wire [15:0] OOPCP2MEM;
//  wire [15:0] OOALUResultMEM;
//  wire [15:0] OStoreMemMEM;
//  wire [2:0] OrdMEM;
//  wire [1:0] Ofwd1EX;
//  wire [1:0] Ofwd2EX;
//  wire [0:0] Ofwd3EX;
//  wire [0:0] OBfwd1;
//  wire [0:0] OBfwd2;
//  wire [0:0] OfwdMEM;

  // Instantiate the CPU module
  // CPU my_cpu (
  //   .clk(clk),
  //   .reset(reset)
//    .OFnewPCCon(OFnewPCCon),
//    .OFPCCon(OFPCCon),
//    .OirCon(OirCon),
//    .OjumpCon(OjumpCon),
//    .OnewPCInCon(OnewPCInCon),
//    .OloadAddrWB(OloadAddrWB),
//    .OloadDataWB(OloadDataWB),
//    .OrfWriteWBCon(OrfWriteWBCon),
//    .ORegWriteWB(ORegWriteWB),
//    .OORegWriteEX(OORegWriteEX),
//    .OORegStoreEX(OORegStoreEX),
//    .OOMemWriteEX(OOMemWriteEX),
//    .OOMemReadEX(OOMemReadEX),
//    .OOPCP2EX(OOPCP2EX),
//    .OOALUResultEX(OOALUResultEX),
//    .OO3rdArgEX(OO3rdArgEX),
//    .OORs1EX(OORs1EX),
//    .OORs2EX(OORs2EX),
//    .OORdEX(OORdEX),
//    .OORegWriteMEM(OORegWriteMEM),
//    .OORegStoreMEM(OORegStoreMEM),
//    .OOPCP2MEM(OOPCP2MEM),
//    .OOALUResultMEM(OOALUResultMEM),
//    .OStoreMemMEM(OStoreMemMEM),
//    .OrdMEM(OrdMEM),
//    .Ofwd1EX(Ofwd1EX),
//    .Ofwd2EX(Ofwd2EX),
//    .Ofwd3EX(Ofwd3EX),
//    .OBfwd1(OBfwd1),
//    .OBfwd2(OBfwd2),
//    .OfwdMEM(OfwdMEM)
  // );

  // Instantiate the CPU module
  CPU uut (
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(out)
  );
  
parameter HALF_PERIOD = 8.65; // cyc time

integer failures = 0;
integer success = 0;

integer instCount = 0;

  // Clock generation
  initial begin
    clk = 0;
    forever begin
        #(HALF_PERIOD);
        clk = ~clk;
    end
end

  // Reset generation
  initial begin
    // -- Timing Analysis Tests -- 

    in = 'h13B0;
    reset = 1;
    #(2*HALF_PERIOD);
    instCount = instCount + 1;
    reset = 0;
    while (out != 'h000B) begin
      #(2*HALF_PERIOD);
      instCount = instCount + 1;
    end
    success = success + 1;
    $display("Test completed at %d -> %d", in, out);
    $display("Instructions executed: %d", instCount);
    // ---------------------------

    // in = 4;
    // reset = 1;
    // #(2*HALF_PERIOD);
    // reset = 0;
    // while (out != 3) begin
    //   #(2*HALF_PERIOD);
    // end
    // success = success + 1;
    // $display("Test completed at %d -> %d", in, out);
    // in = 5;

    // #(2*HALF_PERIOD);
    // reset = 0;
    // while (out != 2) begin
    //   #(2*HALF_PERIOD);
    // end
    // success = success + 1;
    // $display("Test completed at %d -> %d", in, out);
    // in = 12;

    // #(2*HALF_PERIOD);
    // reset = 0;
    // while (out != 5) begin
    //   #(2*HALF_PERIOD);
    // end
    // success = success + 1;
    // $display("Test completed at %d -> %d", in, out);
    // in = 60;

    // #(2*HALF_PERIOD);
    // reset = 0;
    // while (out != 7) begin
    //   #(2*HALF_PERIOD);
    // end
    // success = success + 1;
    // $display("Test completed at %d -> %d", in, out);

    $stop;
  end

  

endmodule
