module EX_MEM(
    input [0:0] IRegWrite,
    input [0:0] IMemWrite,
    input [0:0] IMemRead,
    input [1:0] IRegStore,
    input [15:0] IPCP2,
    input [15:0] IALUResult,
    input [15:0] I3rdArg,
    input [2:0] IRd,
    input CLK,
    input Reset,
    input RegWrite,
    output reg[0:0] ORegWrite,
    output reg[0:0] OMemWrite,
    output reg[0:0] OMemRead,
    output reg[1:0] ORegStore,
    output reg[15:0] OPCP2,
    output reg[15:0] OALUResult,
    output reg[15:0] O3rdArg,
    output reg[2:0] ORd
);

always @ (posedge(CLK))
begin
    if (Reset != 1) begin
        if(RegWrite == 1) begin
            ORegWrite = IRegWrite;
            OMemWrite = IMemWrite;
            OMemRead = IMemRead;
            ORegStore = IRegStore;
            OPCP2 = IPCP2;
            OALUResult = IALUResult;
            O3rdArg = I3rdArg;
            ORd = IRd;
        end
    end else begin 
            ORegWrite = 0;
            OMemWrite = 0;
            OMemRead = 0;
            ORegStore = 0;
            OPCP2 = 0;
            OALUResult = 0;
            O3rdArg = 0;
            ORd = 0;
    end
end

endmodule
