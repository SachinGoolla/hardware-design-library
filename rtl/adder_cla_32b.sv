module adder_cla_32b (
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic        cin_i,
    output logic [31:0] sum_o,
    output logic        cout_o
);

    logic [31:0] g, p;
    
    // Suppressing UNOPTFLAT (Optimization) and ALWCOMBORDER (Execution Order)
    // because this is a legitimate carry-chain dependency.
    /* verilator lint_off UNOPTFLAT */
    /* verilator lint_off ALWCOMBORDER */
    logic [32:0] c;
    /* verilator lint_on UNOPTFLAT */
    /* verilator lint_on ALWCOMBORDER */

    assign g = a_i & b_i;
    assign p = a_i ^ b_i;

    always_comb begin
        c[0] = cin_i;
        for (int i = 0; i < 32; i++) begin
            c[i+1] = g[i] | (p[i] & c[i]);
        end
    end

    assign sum_o  = p ^ c[31:0];
    assign cout_o = c[32];

endmodule
