module Fetch_Stage(
    input [15:0] pc_in,
    input reset,
    input clk,
    output reg [15:0] new_pc,
    output [15:0] old_pcp2,
    output reg [15:0] old_pc,
    output [15:0] ir
);

wire [15:0] pc_out;

Register pc (
    .reg_input(pc_in),
    .reg_write(1'b1),
    .reset(reset),
    .CLK(~clk),
    .reg_output(pc_out)
);

wire [15:0] delayed_pc;

Register current_pc(
    .reg_input(pc_out),
    .reg_write(1'b1),
    .reset(reset),
    .CLK(clk),
    .reg_output(delayed_pc)
);

wire [15:0] current_pcp2_con;
assign current_pcp2_con = pc_out + 2;

Register current_pcp2(
    .reg_input(current_pcp2_con),
    .reg_write(1'b1),
    .reset(reset),
    .CLK(clk),
    .reg_output(old_pcp2)
);

Memory_Text instruction_memory(
    .data(16'h0000),
    .addr(pc_out),
    .we(1'b0),
    .clk(clk),
    .q(ir)
);
always @(*) begin
    if (reset == 0) begin
        new_pc <= pc_out + 2;
        old_pc <= delayed_pc;
    end
    else begin
        new_pc <= 2;
        old_pc <= 0;
    end
end
// always @(posedge(clk)) begin
// new_pc <= pc_out + 2;
// old_pc <= delayed_pc;
// end
endmodule