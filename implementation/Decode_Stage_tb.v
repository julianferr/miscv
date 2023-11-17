`timescale 1 ns / 1 ps

module Decode_Stage_tb();
  reg [15:0] IPCP2;
  reg [15:0] pc_in;
  reg [15:0] ir_in;
  reg [2:0] loadAddr;
  reg [15:0] loadData;
  reg [1:0] comparatorMux1Control;
  reg [1:0] comparatorMux2Control;
  reg [15:0] comparatorMuxForwardMEM;
  reg [15:0] comparatorMuxForwardWB;
  reg rf_write;
  reg reset;
  reg clk;
  reg RB_write;
  wire RegWrite;
  wire ALUSrc;
  wire [2:0] ALUOp;
  wire [0:0] MemWrite;
  wire [0:0] MemRead;
  wire [1:0] RegStore;
  wire [15:0] OPCP2;
  wire signed[15:0] Arg1;
  wire signed[15:0] Arg2;
  wire signed[15:0] Arg3;
  wire signed[15:0] Imm;
  wire [2:0] Rs1;
  wire [2:0] Rs2;
  wire [2:0] Rd;
  wire [15:0] new_pc;
  wire [0:0] jump;

  Decode_Stage uut (
    .IPCP2(IPCP2),
    .pc_in(pc_in),
    .ir_in(ir_in),
    .loadAddr(loadAddr),
    .loadData(loadData),
    .comparatorMux1Control(comparatorMux1Control),
    .comparatorMux2Control(comparatorMux2Control),
    .comparatorMuxForwardMEM(comparatorMuxForwardMEM),
    .comparatorMuxForwardWB(comparatorMuxForwardWB),
    .rf_write(rf_write),
    .reset(reset),
    .clk(clk),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .RegStore(RegStore),
    .RB_write(RB_write),
    .OPCP2(OPCP2),
    .Arg1(Arg1),
    .Arg2(Arg2),
    .Arg3(Arg3),
    .Imm(Imm),
    .Rs1(Rs1),
    .Rs2(Rs2),
    .Rd(Rd),
    .new_pc(new_pc),
    .jump(jump)
  );

  parameter HALF_PERIOD = 50;

  integer failures = 0;

  initial begin 
    clk = 0;
    forever begin
      #(HALF_PERIOD);
      clk = ~clk;
    end
  end

  initial begin

    //Initialize
    #(HALF_PERIOD);
    reset = 1;
    #(2*HALF_PERIOD);
    reset = 0;
    RB_write = 1;

    pc_in = 2;
    IPCP2 = pc_in + 2;
    ir_in = 0;
    loadAddr = 0;
    loadData = 0;
    comparatorMux1Control = 2;
    comparatorMux2Control = 2;
    comparatorMuxForwardWB = 0;
    comparatorMuxForwardMEM = 0;
    rf_write = 0;

    #(2*HALF_PERIOD);
  
    //TEST 1 Loading data
    pc_in = 2;
    IPCP2 = pc_in + 2;
    ir_in = 0;
    loadAddr = 5;
    loadData = 16;
    rf_write = 1;

    #(2*HALF_PERIOD);

    loadAddr = 6;
    loadData = 10;
    rf_write = 1;

    #(2*HALF_PERIOD);

    loadAddr = 4;
    loadData = -8;
    rf_write = 1;

    #(2*HALF_PERIOD);

    //Testing output for R-type

    rf_write = 0;
    ir_in = 'b0001110101100000; //rd:x4 = rs2:x6 - rs1:x5 (r-type)

    #(2*HALF_PERIOD);

    if(RegWrite != 1 || ALUSrc != 1 || ALUOp != 'b010 || MemWrite != 0 ||
    MemRead != 0 || RegStore != 1 || OPCP2 != 4 || Arg1 != 16 || 
    Arg2 != 10 || Arg3 != -8 || Rs1 != 'b101 || Rs2 != 'b110 || Rd != 'b100 || jump != 1) begin
      failures = failures + 1;
      $display("Failure in R-type %d", $time);
    end

    //Testing output for I-type

    rf_write = 0;
    ir_in = 'b0001100101100001; //rd:x4 = rs1:x5 + 12 (I-type)

    #(2*HALF_PERIOD);

    if(RegWrite != 1 || ALUSrc != 0 || ALUOp != 'b001 || MemWrite != 0 ||
    MemRead != 0 || RegStore != 1 || OPCP2 != IPCP2 || Imm != 12 || Arg1 != 16 || 
    Arg3 != -8 || Rs1 != 'b101 || Rd != 'b100 || jump != 1) begin
      failures = failures + 1;
      $display("Failure in I-type");
    end

    //Testing output for M-type

    rf_write = 0;
    ir_in = 'b0001010101100010; //rd:x4 = Mem[rs1:x5 + 10] (M-type)

    #(2*HALF_PERIOD);

    if(RegWrite != 1 || ALUSrc != 0 || ALUOp != 'b001 || MemWrite != 0 ||
    MemRead != 1 || RegStore != 0 || OPCP2 != IPCP2 || Imm != 10 || Arg1 != 16 || 
    Arg3 != -8 || Rs1 != 'b101 || Rd != 'b100 || jump != 1) begin
      failures = failures + 1;
      $display("Failure in M-type load");
    end

    //Testing output for M-type

    rf_write = 0;
    ir_in = 'b0001010101100011; //Mem[rs1:x5 + 10] = rd:x4 (M-type)

    #(2*HALF_PERIOD);

    if(RegWrite != 0 || ALUSrc != 0 || ALUOp != 'b001 || MemWrite != 1 ||
    MemRead != 0 || OPCP2 != IPCP2 || Imm != 10 || Arg1 != 16 || 
    Arg3 != -8 || Rs1 != 'b101 || Rd != 'b100 || jump != 1) begin
      failures = failures + 1;
      $display("Failure in M-type store");
    end
    
    //Testing output for Y-type

    loadAddr = 5;
    loadData = 50;
    rf_write = 1;

    #(2*HALF_PERIOD);

    loadAddr = 6;
    loadData = 60;

    #(2*HALF_PERIOD);

    rf_write = 0;
    ir_in = 'hFD74; //x5 Y= x6, -2 (Y-type) doesnt jump

    #(2*HALF_PERIOD);

    if(RegWrite != 0 || MemWrite != 0 ||
    MemRead != 0 || OPCP2 != IPCP2 || Imm != -4 || jump != 1) begin
      failures = failures + 1;
      $display("Failure in Y-type");
    end

    ir_in = 'h0D4D; //x5 Y< x6, 1 (Y-type) jumps

    #(2*HALF_PERIOD);

    if(RegWrite != 0 || MemWrite != 0 || MemRead != 0 || Imm != 2 || jump != 0) begin
      failures = failures + 1;
      $display("Failure in Y-type");
    end

    loadAddr = 5;
    loadData = 60;
    rf_write = 1;

    #(2*HALF_PERIOD);

    rf_write = 0;
    ir_in = 'h0D4C; //x5 Y= x6, 1 (Y-type) jumps

    #(2*HALF_PERIOD);

    if(RegWrite != 0 || MemWrite != 0 || MemRead != 0 || Imm != 2 || jump != 0) begin
      failures = failures + 1;
      $display("Failure in Y-type");
    end

    ir_in = 'hFD5D; //x5 Y< x6, -2 (Y-type) doesn't jump

    #(2*HALF_PERIOD);

    if(RegWrite != 0 || MemWrite != 0 ||
    MemRead != 0 || OPCP2 != IPCP2 || Imm != -10 || jump != 1) begin
      failures = failures + 1;
      $display("Failure in Y-type");
    end

    ir_in = 'hFA8E; //ra \/ -23

    #(2*HALF_PERIOD);

    if(RegWrite != 0 || MemWrite != 0 ||
    MemRead != 0 || OPCP2 != IPCP2 || Imm != -46 || jump != 0) begin
      failures = failures + 1;
      $display("Failure in J-type");
    end
    



    // #(4*HALF_PERIOD);

    // if ( RegWrite != 0 ||
    //   ALUSrc != 0 ||
    //   ALUOp != 0 ||
    //   MemWrite != 0 ||
    //   MemRead != 0 ||
    //   RegStore != 0 ||
    //   OPCP2 != 0 ||
    //   Arg1 != 0 ||
    //   Arg2 != 0 ||
    //   Arg3 != 0 ||
    //   Imm != 0 ||
    //   Rs1 != 0 ||
    //   Rs2 != 0 ||
    //   Rd != 0 ||
    //   new_pc != 0 ||
    //   jump != 0) begin
    //   $display("The Block does not initialize. No other tests will be run.");
		//   $stop;
    // end

    // reset = 0;
    // #(4*HALF_PERIOD);

    // IPCP2 = $random;
    // pc_in = $random;
    // ir_in = $random;
    // loadAddr = $random;
    // loadData = $random;
    // reset = 0;

    // if ( RegWrite != 0 ||
    //   ALUSrc != 0 ||
    //   ALUOp != 0 || 
    //   MemWrite != 0 ||
    //   MemRead != 0 ||
    //   RegStore != 0 ||
    //   OPCP2 != 0 || 
    //   Arg1 != 0 ||
    //   Arg2 != 0 ||
    //   Arg3 != 0 ||
    //   Imm != 0 ||
    //   Rs1 != 0 ||
    //   Rs2 != 0 ||
    //   Rd != 0 ||
    //   new_pc != 0 ||
    //   jump != 0) begin
    //   $display("The Block writes when it should not. No further testing will be done.");
		//   $stop;
    // end

    // rf_write = 1;

    // // IPCP2 = ;
    // // pc_in = ;
    // // ir_in = ;
    // // loadAddr = ;
    // // loadData = ;
    // // #(2*HALF_PERIOD);

    // // if ( RegWrite !=  ||
    // //   ALUSrc !=  ||
    // //   ALUOp !=  || 
    // //   MemWrite !=  ||
    // //   MemRead !=  || 
    // //   RegStore !=  ||
    // //   OPCP2 !=  ||
    // //   Arg1 !=  ||
    // //   Arg2 !=  ||
    // //   Arg3 !=  ||
    // //   Imm !=  ||
    // //   Rs1 !=  ||
    // //   Rs2 !=  ||
    // //   Rd !=  ||
    // //   new_pc !=  ||
    // //   jump != ) begin
    // //   $display("Error:");
    // // // end

    // IPCP2 = 200;
    // pc_in = 0;
    // ir_in = 0;
    // loadAddr = 0;
    // loadData = 0;
    // #(2*HALF_PERIOD);

    // if ( RegWrite != 0 ||
    //   ALUSrc != 0 ||
    //   ALUOp != 0 || 
    //   MemWrite != 0 ||
    //   MemRead != 0 || 
    //   RegStore != 0 ||
    //   OPCP2 != 200 ||
    //   Arg1 != 0 ||
    //   Arg2 != 0 ||
    //   Arg3 != 0 ||
    //   Imm != 0 ||
    //   Rs1 != 0 ||
    //   Rs2 != 0 ||
    //   Rd != 0 ||
    //   new_pc != 0 ||
    //   jump != 0) begin
    //   $display("Error: PC + 2 does not propogate correctly.");
    // end

    // IPCP2 = 0;
    // pc_in = 13;
    // ir_in = 0;
    // loadAddr = 0;
    // loadData = 0;
    // #(2*HALF_PERIOD);

    // if ( RegWrite != 0 ||
    //   ALUSrc != 0 ||
    //   ALUOp != 0 ||
    //   MemWrite != 0 ||
    //   MemRead != 0 ||
    //   RegStore != 0 ||
    //   OPCP2 != 0 ||
    //   Arg1 != 0 ||
    //   Arg2 != 0 ||
    //   Arg3 != 0 ||
    //   Imm != 0 ||
    //   Rs1 != 0 ||
    //   Rs2 != 0 ||
    //   Rd != 0 ||
    //   new_pc != 13 ||
    //   jump != 0) begin
    //   $display("Error: PC in does not add correctly.");
    // end

    // // IPCP2 = 0;
    // // pc_in = 0;
    // // ir_in = 0;
    // // loadAddr = 0;
    // // loadData = 0;
    // // #(2*HALF_PERIOD);

    // // if ( RegWrite != 0 ||
    // //   ALUSrc != 0 ||
    // //   ALUOp != 0 ||
    // //   MemWrite != 0 ||
    // //   MemRead != 0 ||
    // //   RegStore != 0 ||
    // //   OPCP2 != 0 ||
    // //   Arg1 != 0 ||
    // //   Arg2 != 0 ||
    // //   Arg3 != 0 ||
    // //   Imm != 0 ||
    // //   Rs1 != 0 ||
    // //   Rs2 != 0 ||
    // //   Rd != 0 ||
    // //   new_pc != 0 ||
    // //   jump != 0) begin
    // //   $display("Error: PC + 2 does not propogate corectly.");
    // // end

    $display("Decode_Stage Tests finished");
    $stop;
  end

endmodule
