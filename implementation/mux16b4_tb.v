`timescale 1 ns / 1 ps 

module mux16b4_tb();
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [1:0] s;
    
    wire [15:0] r;

    mux16b2 UUT(
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .s(s),
        .r(r)
    );

    initial begin
        a = 16'b0000000000000000;
        b = 16'b1111111100000000;
        b = 16'b1111111111110000;
        b = 16'b1111111111111111;
        s = 2'b00;

        repeat(8) begin
            if(s[1] == 0) begin
                if (s[0] == 0) begin
                    if (r != a) begin
                        $display("Mux Test 1 failed");
                    end     
                end else begin
                    if (r != b) begin
                        $display("Mux Test 1 failed");
                    end     
                end
            end else begin
                if (s[0] == 0) begin
                    if (r != c) begin
                        $display("Mux Test 1 failed");
                    end     
                end else begin
                    if (r != d) begin
                        $display("Mux Test 1 failed");
                    end     
                end
            end
            s[0] = 1 - (1*s[0]); 
            s[1] = 2 - (1 - s[1]) - (1 - s[0]);
        end

    end 

endmodule