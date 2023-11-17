module ID_EX(
    input [0:0] IRegWrite,
    input [0:0] IALUSrc,
    input [2:0] IALUOP,
    input [0:0] IMemWrite,
    input [0:0] IMemRead,
    input [1:0] IRegStore,
    input [15:0] IPCP2,
    input [15:0] I1stArg,
    input [15:0] I2ndArg,
    input [15:0] I3rdArg,
    input [15:0] IImm,
    input [2:0] IRs1,
    input [2:0] IRs2,
    input [2:0] IRd,
    input CLK,
    input Reset,
    input RB_write,
    output reg[0:0] ORegWrite,
    output reg[0:0] OALUSrc,
    output reg[2:0] OALUOP,
    output reg[0:0] OMemWrite,
    output reg[0:0] OMemRead,
    output reg[1:0] ORegStore,
    output reg[15:0] OPCP2,
    output reg[15:0] O1stArg,
    output reg[15:0] O2ndArg,
    output reg[15:0] O3rdArg,
    output reg[15:0] OImm,
    output reg[2:0] ORs1,
    output reg[2:0] ORs2,
    output reg[2:0] ORd
);

always @ (posedge(CLK))
begin
    if (Reset != 1) begin
        if(RB_write == 1) begin
            ORegWrite <= IRegWrite;
            OALUSrc <= IALUSrc;
            OALUOP <= IALUOP;
            OMemWrite <= IMemWrite;
            OMemRead <= IMemRead;
            ORegStore <= IRegStore;
            OPCP2 <= IPCP2;
            O1stArg <= I1stArg;
            O2ndArg <= I2ndArg;
            O3rdArg <= I3rdArg;
            OImm <= IImm;
            ORs1 <= IRs1;
            ORs2 <= IRs2;
            ORd <= IRd;
        end
    end else begin 
            ORegWrite = 0;
            OALUSrc = 0;
            OALUOP = 0;
            OMemWrite = 0;
            OMemRead = 0;
            ORegStore = 0;
            OPCP2 = 0;
            O1stArg = 0;
            O2ndArg = 0;
            O3rdArg = 0;
            OImm = 0;
            ORs1 = 0;
            ORs2 = 0;
            ORd = 0;
    end
end

endmodule
