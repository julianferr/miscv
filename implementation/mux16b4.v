module mux16b4(
    input[15:0] a,
    input[15:0] b,
    input[15:0] c,
    input[15:0] d,
    input[1:0] s,
    output[15:0] r
    );

assign r = s[1] ? (s[0] ? d : c) : (s[0] ? b : a); 

endmodule