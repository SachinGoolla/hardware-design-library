module adder_ksa_32bit (
    input  logic        clk_i,    
    input  logic        rst_ni,   
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic        cin_i,
    output logic [31:0] sum_o,
    output logic        cout_o
);

    // --- STAGE 1: dist 1, 2, 4 (Balanced G3/P3 calculation) ---
    logic [31:0] g0, p0, g1, p1, g2, p2, g3, p3;
    
    assign p0 = a_i ^ b_i;
    assign g0[0] = (a_i[0] & b_i[0]) | (p0[0] & cin_i);
    assign g0[31:1] = a_i[31:1] & b_i[31:1];

    assign g1 = {g0[31:1] | (p0[31:1] & g0[30:0]), g0[0]};
    assign p1 = {p0[31:1] & p0[30:0], p0[0]};

    assign g2 = {g1[31:2] | (p1[31:2] & g1[29:0]), g1[1:0]};
    assign p2 = {p1[31:2] & p1[29:0], p1[1:0]};

    assign g3 = {g2[31:4] | (p2[31:4] & g2[27:0]), g2[3:0]};
    assign p3 = {p2[31:4] & p2[27:0], p2[3:0]};

    // --- PIPELINE REGISTERS ---
    logic [31:0] g3_q, p3_q, p0_q;
    logic        cin_q;
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            g3_q  <= '0;
            p3_q  <= '0;
            p0_q  <= '0;
            cin_q <= '0;
        end else begin
            g3_q  <= g3;
            p3_q  <= p3;
            p0_q  <= p0;
            cin_q <= cin_i;
        end
    end

    // --- STAGE 2: dist 8, 16 + Final Sum ---
    logic [31:0] g4, g5;

    /* verilator lint_off UNUSEDSIGNAL */
    logic [31:0] p4; // Bits [15:0] unused in final G5 reduction
    /* verilator lint_on UNUSEDSIGNAL */

    assign g4 = {g3_q[31:8] | (p3_q[31:8] & g3_q[23:0]), g3_q[7:0]};
    assign p4 = {p3_q[31:8] & p3_q[23:0], p3_q[7:0]};

    assign g5 = {g4[31:16] | (p4[31:16] & g4[15:0]), g4[15:0]};

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            sum_o  <= '0;
            cout_o <= '0;
        end else begin
            sum_o[0]    <= p0_q[0] ^ cin_q;
            sum_o[31:1] <= p0_q[31:1] ^ g5[30:0];
            cout_o      <= g5[31];
        end
    end

`ifndef SYNTHESIS
    // Internal simulator dumping logic
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, adder_ksa_32bit);
    end
`endif

endmodule
