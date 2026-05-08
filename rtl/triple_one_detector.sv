module triple_one_detector (
    input  logic [9:0] data_i,
    output logic       detect_o
);
    // Optimized sliding window
    logic [9:0] window;
    assign window = data_i & (data_i >> 1) & (data_i >> 2);
    assign detect_o = |window;
endmodule
