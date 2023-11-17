module Memory_Stage(
    input reset,
    input clk,
    input IRegWrite,
    input [1:0] IRegStore,
    input MemWrite,
    input MemRead,
    input [15:0] IPCP2,
    input [15:0] IALUResult,
    input [15:0] thirdArg,
    input [2:0] rdMem,
    input [15:0] loadData,
    input DataInSelect,
    input [15:0] in,
    output ORegWrite,
    output [1:0] ORegStore,
    output [15:0] OPCP2,
    output [15:0] OALUResult,
    output [15:0] OStoreMem,
    output [2:0] rdWB,
    output [15:0] out
);

wire [0:0] MemWriteCon;
wire [0:0] MemReadCon;
wire [15:0] thirdArgCon;
wire [15:0] ALUResultCon;

EX_MEM EXMEMRB(
    .IRegWrite(IRegWrite),
    .IMemWrite(MemWrite),
    .IMemRead(MemRead),
    .IRegStore(IRegStore),
    .IPCP2(IPCP2),
    .IALUResult(IALUResult),
    .I3rdArg(thirdArg),
    .IRd(rdMem),
    .CLK(clk),
    .Reset(reset),
    .RegWrite(1'b1),
    .ORegWrite(ORegWrite),
    .OMemWrite(MemWriteCon),
    .OMemRead(MemReadCon),
    .ORegStore(ORegStore),
    .OPCP2(OPCP2),
    .OALUResult(ALUResultCon),
    .O3rdArg(thirdArgCon),
    .ORd(rdWB)
);

assign OALUResult = ALUResultCon;

wire [15:0] dataInCon;

mux16b2 dataInMux(
    .a(loadData),
    .b(thirdArgCon),
    .s(DataInSelect),
    .r(dataInCon)
);

wire [15:0] StoreMemCon;

Memory_Data mem (
	.data(dataInCon),
	.addr(ALUResultCon),
	.we(MemWriteCon),
    .in(in),
	.clk(clk),
    .out(out),
	.q(StoreMemCon)
);

assign OStoreMem = StoreMemCon;

endmodule