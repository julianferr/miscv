module Register(
    input [15:0] reg_input,
    input [0:0] reg_write,
    input [0:0] reset,
    input [0:0] CLK,
    output reg [15:0] reg_output
);

always @ (posedge(CLK))
begin
    if (reset != 1) begin
        if (reg_write == 1) begin
            reg_output = reg_input;
        end
        
    end else begin 
        reg_output = 'h0000;
    end
end

endmodule