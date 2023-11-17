`timescale 1 ns / 1 ps 

module mux16b2_tb();
    reg [15:0] a;
    reg [15:0] b;
    reg [0:0] s;
    
    wire [15:0] r;

    mux16b2 UUT(
        .a(a),
        .b(b),
        .s(s),
        .r(r)
    );

    initial begin
        a = 16'b0000000000000000;
        b = 16'b1111111111111111;
        s = 0;

        repeat(10) begin
            if (s == 0 && r != a) begin
                $display("Mux Test 1 failed");
            end
            if (s == 1 && r != b) begin
                $display("Mux Test 2 failed");
            end
            s = 1 - (1*s); 
        end

        $display("Mux Test finished");
    end 

endmodule