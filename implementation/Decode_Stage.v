module Decode_Stage(
    input [15:0] IPCP2,
    input [15:0] pc_in,
    input [15:0] ir_in,
    input [2:0] loadAddr,
    input [15:0] loadData,
    input [1:0] comparatorMux1Control,
    input [1:0] comparatorMux2Control,
    input [15:0] comparatorMuxForwardMEM,
    input [15:0] comparatorMuxForwardWB,
    input rf_write,
    input reset,
    input clk,
    input RB_write,
    output RegWrite,
    output ALUSrc,
    output [2:0] ALUOp,
    output [0:0] MemWrite,
    output [0:0] MemRead,
    output [1:0] RegStore,
    output [15:0] OPCP2,
    output [15:0] Arg1,
    output [15:0] Arg2,
    output [15:0] Arg3,
    output [15:0] Imm,
    output [2:0] Rs1,
    output [2:0] Rs2,
    output [2:0] Rd,
    output [15:0] new_pc,
    output [0:0] jump
);

wire [15:0] pc;
wire [15:0] ir;

IF_ID IFIDRB(
    .IPCP2(IPCP2),
    .IPC(pc_in),
    .IIR(ir_in),
    .CLK(clk),
    .Reset(reset),
    .RegWrite(RB_write),
    .OPCP2(OPCP2),
    .OPC(pc),
    .OIR(ir)
);

assign Rs1 = ir[8:6];
assign Rs2 = ir[11:9];
assign Rd = ir[5:3];

wire BranchCon;
wire JumpCon;

Control CUnit(
    .opcode(ir[2:0]),
    .func(ir[15:12]),
    .reset(reset),
    .CLK(clk),
    .RegWrite(RegWrite),
    .ALUsrc(ALUSrc),
    .ALUop(ALUOp),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .RegStore(RegStore),
    .Branch(BranchCon),
    .JumpOut(JumpCon)
);

wire [15:0] arg1;
wire [15:0] arg2;
wire [15:0] arg3;

Register_File Regs(
    .Reg_address1(ir[8:6]),
    .Reg_address2(ir[11:9]),
    .Reg_address3(ir[5:3]),
    .Reg_input_address(loadAddr),
    .Reg_input_data(loadData),
    .CLK(clk),
    .Reset(reset),
    .Reg_Write(rf_write),
    .Reg_output1(arg1),
    .Reg_output2(arg2),
    .Reg_output3(arg3)
);

wire [15:0] immCon;

Imm_Gen genie(
    .instruction(ir),
    .immediate(immCon)
);

assign Imm = immCon;

wire [15:0] comparatorData1;
wire [15:0] comparatorData2;

mux16b4 comparatorMux1(
    .a(comparatorMuxForwardMEM),
    .b(comparatorMuxForwardWB),
    .c(arg1),
    .d(16'b0),
    .s(comparatorMux1Control),
    .r(comparatorData1)
);

mux16b4 comparatorMux2(
    .a(comparatorMuxForwardMEM),
    .b(comparatorMuxForwardWB),
    .c(arg2),
    .d(16'b0),
    .s(comparatorMux2Control),
    .r(comparatorData2)
);

reg [15:0] pc_added;

wire branchCompCon;

Comparator comp(
    .FirstInput(comparatorData1),
    .SecondInput(comparatorData2),
    .CLK(clk),
    .OPCode(ir[2:0]),
    .BranchComparison(branchCompCon)
);

assign jump = ~(BranchCon && branchCompCon);
always @ * begin
    pc_added = pc + immCon;
end

mux16b2 jumpMux(
    .a(pc_added),
    .b(arg3),
    .s(JumpCon),
    .r(new_pc)
);

assign Arg1 = arg1;
assign Arg2 = arg2;
assign Arg3 = arg3;

endmodule