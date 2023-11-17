/*
The immediate generation logic must choose between sign-extending a field in instruction bits 
15:12 for R register instructions, 
13:9 for I immediate instructions,
15:9 for M memory instructions, 
15:12 and 5:3 with bit shift left 1 for Y conditional branch,
15:6 with bit shift left 1 for J jump instructions.
Since the input is all 16 bits of the instruction, it can use the opcode bits of the instruction to select the proper field. 
*/

module Imm_Gen(
    input [15:0] instruction,
    output reg [15:0] immediate
);

wire [2:0] opcode = instruction[2:0];

always @* begin
    case (opcode)
        3'b001: immediate = {{11{instruction[13]}}, {instruction[13:9]}};
        3'b010: immediate = {{9{instruction[15]}}, {instruction[15:9]}};
        3'b011: immediate = {{9{instruction[15]}}, {instruction[15:9]}};
        3'b100: immediate = {{9{instruction[15]}}, {instruction[15:12]}, {instruction[5:3]}, 1'b0};
        3'b101: immediate = {{8{instruction[15]}}, {instruction[15:12]}, {instruction[5:3]}, 1'b0};
        3'b110: immediate = {{5{instruction[15]}}, {instruction[15:6]}, 1'b0};
        3'b111: immediate = {{5{instruction[15]}}, {instruction[15:6]}, 1'b0};
        default: immediate = 16'b0;
endcase
end

endmodule

