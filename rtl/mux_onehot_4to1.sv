module mux_onehot_4to1 #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] a_i, b_i, c_i, d_i,
    input  logic [3:0]       sel_onehot_i, // One-hot encoded
    output logic [WIDTH-1:0] data_o
);
    // Using a simple AND-OR structure
    // This is the fastest possible mux architecture in silicon
    assign data_o = (a_i & {WIDTH{sel_onehot_i[0]}}) |
                    (b_i & {WIDTH{sel_onehot_i[1]}}) |
                    (c_i & {WIDTH{sel_onehot_i[2]}}) |
                    (d_i & {WIDTH{sel_onehot_i[3]}});
endmodule
