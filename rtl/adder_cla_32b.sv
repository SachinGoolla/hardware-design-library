module adder_cla_32b (
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic        cin_i,
    output logic [31:0] sum_o,
    output logic        cout_o
);

    // Generate and Propagate signals
    logic [31:0] g, p;
    logic [32:0] c;

    assign g = a_i & b_i;
    assign p = a_i ^ b_i;

    // Carry Lookahead Logic (Simplified for readability, usually expanded into a tree)
    assign c[0] = cin_i;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign sum_o  = p ^ c[31:0];
    assign cout_o = c[32];

endmodule
