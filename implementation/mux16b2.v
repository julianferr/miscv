module mux16b2(
    input[15:0] a,
    input[15:0] b,
    input[0:0] s,
    output[15:0] r
);

assign r = (s == 0) ? a : b;

endmodule