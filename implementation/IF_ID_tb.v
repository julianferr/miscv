`timescale 1 ns / 1 ps 

module IF_ID_tb();
    reg [15:0] IPCP2;
    reg [15:0] IPC;
    reg [15:0] IIR;
    reg CLK;
    reg Reset;
    reg RegWrite;
    wire [15:0] OPCP2;
    wire [15:0] OPC;
    wire [15:0] OIR;

    IF_ID DUT (
        .IPCP2(IPCP2),
        .IPC(IPC),
        .IIR(IIR),
        .CLK(CLK),
        .Reset(Reset),
        .RegWrite(RegWrite),
        .OPCP2(OPCP2),
        .OPC(OPC),
        .OIR(OIR)
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

        IPCP2 = 16'h1234;
        IPC = 16'h5678;
        IIR = 16'h9abc;

        #(2*HALF_PERIOD);

        if(OPC != 0 || OIR != 0 || OPCP2 != 0) begin
            $display("Test 1: Reset error");
        end

        Reset = 0;

        #(2*HALF_PERIOD);

        if(OPC != IPC || OIR != IIR || OPCP2 != IPCP2) begin
            $display("Test 2: Register persistence error");
        end

        RegWrite = 0;
        IPC = 'hFFFF;
        IIR = 'hAAAA;

        #(2*HALF_PERIOD);

        if(OPC == IPC || OIR == IIR || OPCP2 != IPCP2) begin
            $display("Test 3: Register writes without write bit set");
        end

        $display("IF ID Test finished");

    end

endmodule