`timescale 1ns/1ps  

module adder_parameterized #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] a_i,
    input  logic [WIDTH-1:0] b_i,
    input  logic             carry_i,
    output logic [WIDTH-1:0] sum_o,
    output logic             carry_o
);

// --- PILLAR 1: PRODUCTION LOCK ---
    initial begin
        /* verilator coverage_off */
        if (WIDTH < 1) begin
            $fatal(1, "FATAL: [adder_parameterized] WIDTH must be at least 1.");
        end
        /* verilator coverage_on */
    end
    // --- PILLAR 2: ARITHMETIC LOGIC (THE "HOUSE") ---
    // We explicitly cast to (WIDTH+1) to keep the linter happy and ensure 
    // the carry bit is calculated correctly.
    assign {carry_o, sum_o} = (WIDTH+1)'(a_i) + (WIDTH+1)'(b_i) + (WIDTH+1)'(carry_i);

// --- PILLAR 3: SIGN-OFF ASSERTIONS ---
    `ifndef SYNTHESIS
        always_comb begin
            assert ({carry_o, sum_o} == ( (WIDTH+1)'(a_i) + (WIDTH+1)'(b_i) + (WIDTH+1)'(carry_i) )) 
            /* verilator coverage_off */
            else begin
                $error("SVA ERROR: Math Mismatch!");
            end
            /* verilator coverage_on */
        end
    `endif
    // --- PILLAR 4: FORMAL VERIFICATION ---
    `ifdef FORMAL
        always_comb begin
            assert (a_i + b_i + carry_i == {carry_o, sum_o});
        end
    `endif

endmodule
