module CPU(
    input [0:0] clk,
    input [0:0] reset,
    input [15:0] in,
    output [15:0] out
//    output [15:0] OFnewPCCon,
//    output [15:0] OFPCCon,
//    output [15:0] OirCon,
//    output OjumpCon,
//    output [15:0] OnewPCInCon,
//    output [2:0] OloadAddrWB,
//    output [15:0] OloadDataWB,
//    output OORegWriteEX,
//    output [1:0] OORegStoreEX,
//    output OOMemWriteEX,
//    output OOMemReadEX,
//    output [15:0] OOPCP2EX,
//    output [15:0] OOALUResultEX,
//    output [15:0] OO3rdArgEX,
//    output [2:0] OORs1EX,
//    output [2:0] OORs2EX,
//    output [2:0] OORdEX,
//    output OORegWriteMEM,
//    output [1:0] OORegStoreMEM,
//    output [15:0] OOPCP2MEM,
//    output [15:0] OOALUResultMEM,
//    output [15:0] OStoreMemMEM,
//    output [2:0] OrdMEM,
//    output ORegWriteWB,
//    output [1:0] Ofwd1EX,
//    output [1:0] Ofwd2EX,
//    output [0:0] Ofwd3EX,
//    output [0:0] OBfwd1,
//    output [0:0] OBfwd2,
//    output [0:0] OfwdMEM
);

// if id components
wire [15:0] FnewPCCon;
wire [15:0] FPCP2Con;
wire [15:0] FPCCon;
wire [15:0] irCon;

// pc update components (id input components)
wire jumpCon;

wire [15:0] newPCInCon;

// id input components
wire [2:0] loadAddrWB;
wire [15:0] loadDataWB;

// id ex components
wire RegWriteDE;
wire ALUSrcDE;
wire [2:0] ALUOpDE;
wire [0:0] MemWriteDE;
wire [0:0] MemReadDE;
wire [1:0] RegStoreDE;
wire [15:0] OPCP2DE;
wire [15:0] Arg1DE;
wire [15:0] Arg2DE;
wire [15:0] Arg3DE;
wire [15:0] ImmDE;
wire [2:0] Rs1DE;
wire [2:0] Rs2DE;
wire [2:0] RdDE;
wire [15:0] new_pcDE;

//Execute stage components

wire ORegWriteEX;
wire [1:0] ORegStoreEX;
wire OMemWriteEX;
wire OMemReadEX;
wire [15:0] OPCP2EX;
wire [15:0] OALUResultEX;
wire [15:0] O3rdArgEX;
wire [2:0] ORs1EX;
wire [2:0] ORs2EX;
wire [2:0] ORdEX;

//Memory stage components

wire ORegWriteMEM;
wire [1:0] ORegStoreMEM;
wire [15:0] OPCP2MEM;
wire [15:0] OALUResultMEM;
wire [15:0] StoreMemMEM;
wire [2:0] rdMEM;

//Write Stage components

wire RegWriteWB;

//Forwarding components 

wire [1:0] fwd1EX;
wire [1:0] fwd2EX;
wire [0:0] fwd3EX;
wire [1:0] Bfwd1;
wire [1:0] Bfwd2;
wire [0:0] fwdMEM;

mux16b2 pcMux (
    .a(new_pcDE),
    .b(FnewPCCon),
    .s(jumpCon),
    .r(newPCInCon)
);


Fetch_Stage fetch (
    .pc_in(newPCInCon),
    .reset(reset),
    .clk(clk),
    .new_pc(FnewPCCon),
    .old_pcp2(FPCP2Con),
    .old_pc(FPCCon),
    .ir(irCon)
);

Decode_Stage DeStage (
    .IPCP2(FPCP2Con),
    .pc_in(FPCCon),
    .ir_in(irCon),
    .loadAddr(loadAddrWB), 
    .loadData(loadDataWB),  
    .comparatorMux1Control(Bfwd1),
    .comparatorMux2Control(Bfwd2),
    .comparatorMuxForwardMEM(loadDataWB),
    .comparatorMuxForwardWB(loadDataWB),
    .rf_write(RegWriteWB),
    .reset(reset),
    .clk(clk),
    .RB_write(1'b1),
    .RegWrite(RegWriteDE),
    .ALUSrc(ALUSrcDE),
    .ALUOp(ALUOpDE),
    .MemWrite(MemWriteDE),
    .MemRead(MemReadDE),
    .RegStore(RegStoreDE),
    .OPCP2(OPCP2DE),
    .Arg1(Arg1DE),
    .Arg2(Arg2DE),
    .Arg3(Arg3DE),
    .Imm(ImmDE),
    .Rs1(Rs1DE),
    .Rs2(Rs2DE),
    .Rd(RdDE),
    .new_pc(new_pcDE),
    .jump(jumpCon)
);




Execute_Stage EXStage (
    .IRegWrite(RegWriteDE),
    .IALUSrc(ALUSrcDE),
    .IALUOp(ALUOpDE),
    .IMemWrite(MemWriteDE),
    .IMemRead(MemReadDE),
    .IRegStore(RegStoreDE),
    .IPCP2(OPCP2DE),
    .I1stArg(Arg1DE),
    .I2ndArg(Arg2DE),
    .I3rdArg(Arg3DE),
    .Imm(ImmDE),
    .IRs1(Rs1DE),
    .IRs2(Rs2DE),
    .IRd(RdDE),
    .ALUResultMEM(OALUResultMEM),
    .loadDataWB(loadDataWB),
    .muxFwd1select(fwd1EX),
    .muxFwd2select(fwd2EX),
    .muxFwd3select(fwd3EX),
    .reset(reset),
    .clk(clk),
    .RB_write(1'b1),
    .ORegWrite(ORegWriteEX),
    .ORegStore(ORegStoreEX),
    .OMemWrite(OMemWriteEX),
    .OMemRead(OMemReadEX),
    .OPCP2(OPCP2EX),
    .OALUResult(OALUResultEX),
    .O3rdArg(O3rdArgEX),
    .ORs1(ORs1EX),
    .ORs2(ORs2EX),
    .ORd(ORdEX)
);



Memory_Stage MEMStage (
    .reset(reset),
    .clk(clk),
    .IRegWrite(ORegWriteEX),
    .IRegStore(ORegStoreEX),
    .MemWrite(OMemWriteEX),
    .MemRead(OMemReadEX),
    .IPCP2(OPCP2EX),
    .IALUResult(OALUResultEX),
    .thirdArg(O3rdArgEX),
    .rdMem(ORdEX),
    .loadData(loadDataWB),
    .DataInSelect(fwdMEM),
    .in(in),
    .ORegWrite(ORegWriteMEM),
    .ORegStore(ORegStoreMEM),
    .OPCP2(OPCP2MEM),
    .OALUResult(OALUResultMEM),
    .OStoreMem(StoreMemMEM),
    .rdWB(rdMEM),
    .out(out)
);



Write_Stage WBStage (
    .reset(reset),
    .clk(clk),
    .RegWrite(ORegWriteMEM),
    .RegStore(ORegStoreMEM),
    .IPCP2(OPCP2MEM),
    .ALUResult(OALUResultMEM),
    .StoreMem(StoreMemMEM),
    .rdWB(rdMEM),
    .loadData(loadDataWB),
    .loadAddr(loadAddrWB),
    .regWriteOut(RegWriteWB)
);



Forward Forward_Unit (
    .rs1EX(ORs1EX),
    .rs2EX(ORs2EX),
    .rdEX(ORdEX),
    .rdMEM(rdMEM),
    .rdWB(loadAddrWB),
    .rs1(Rs1DE),
    .rs2(Rs2DE),
    .RegWriteMEM(ORegWriteMEM),
	.RegWriteWB(RegWriteWB),
    .fwd1EX(fwd1EX),
    .fwd2EX(fwd2EX),
    .fwd3EX(fwd3EX),
    .Bfwd1(Bfwd1),
    .Bfwd2(Bfwd2),
    .fwdMEM(fwdMEM)
);

//assign OFnewPCCon = FnewPCCon;
//assign OFPCCon = FPCCon;
//assign OirCon = irCon;
//assign OjumpCon = jumpCon;
//assign OnewPCInCon = newPCInCon;
//assign OloadAddrWB = loadAddrWB;
//assign OloadDataWB = loadDataWB;
//assign ORegWriteWB = RegWriteWB;
//assign OORegWriteEX = ORegWriteEX;
//assign OORegStoreEX = ORegStoreEX;
//assign OOMemWriteEX = OMemWriteEX;
//assign OOMemReadEX = OMemReadEX;
//assign OOPCP2EX = OPCP2EX;
//assign OOALUResultEX = OALUResultEX;
//assign OO3rdArgEX = O3rdArgEX;
//assign OORs1EX = ORs1EX;
//assign OORs2EX = ORs2EX;
//assign OORdEX = ORdEX;
//assign OORegWriteMEM = ORegWriteMEM;
//assign OORegStoreMEM = ORegStoreMEM;
//assign OOPCP2MEM = OPCP2MEM;
//assign OOALUResultMEM = OALUResultMEM;
//assign OStoreMemMEM = StoreMemMEM;
//assign OrdMEM = rdMEM;
//assign Ofwd1EX = fwd1EX;
//assign Ofwd2EX = fwd2EX;
//assign Ofwd3EX = fwd3EX;
//assign OBfwd1 = Bfwd1;
//assign OBfwd2 = Bfwd2;
//assign OfwdMEM = fwdMEM;

endmodule