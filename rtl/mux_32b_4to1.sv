module mux_32b_4to1 #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] d0_i, d1_i, d2_i, d3_i,
    input  logic [1:0]       sel_i,
    output logic [WIDTH-1:0] z_o
);

    // Using a selection tree architecture. 
    // This ensures that the delay from any input to output is only 2 MUX levels.
    logic [WIDTH-1:0] stage1_low, stage1_high;

    assign stage1_low  = sel_i[0] ? d1_i : d0_i;
    assign stage1_high = sel_i[0] ? d3_i : d2_i;
    
    assign z_o         = sel_i[1] ? stage1_high : stage1_low;

endmodule
