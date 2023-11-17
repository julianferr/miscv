module Write_Stage(
    input reset,
    input clk,
    input RegWrite,
    input [1:0] RegStore,
    input [15:0] IPCP2,
    input [15:0] ALUResult,
    input [15:0] StoreMem,
    input [2:0] rdWB,
    output [15:0] loadData,
    output [2:0] loadAddr,
    output [0:0] regWriteOut
);

wire [15:0] StoreMemCon;
wire [15:0] ALUResultCon;
wire [1:0] RegStoreCon;
wire [15:0] PCP2Con;


MEM_WB MEMWBRB(
    .IRegWrite(RegWrite),
    .IRegStore(RegStore),
    .IPCP2(IPCP2),
    .IALUResult(ALUResult),
    .IStoreMem(StoreMem),
    .IRd(rdWB),
    .CLK(clk),
    .Reset(reset),
    .RegWrite(1'b1),
    .ORegWrite(regWriteOut),
    .ORegStore(RegStoreCon),
    .OPCP2(PCP2Con),
    .OALUResult(ALUResultCon),
    .OStoreMem(StoreMemCon),
    .ORd(loadAddr)
);

mux16b4 RegStoreMux(
    .a(StoreMemCon),
    .b(ALUResultCon),
    .c(PCP2Con),
    .d(16'b0),
    .s(RegStoreCon),
    .r(loadData)
);

endmodule