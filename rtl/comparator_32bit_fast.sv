module comparator_32bit_fast (
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    output logic        gt_o,
    output logic        eq_o,
    output logic        lt_o
);

    // Level 0: Bit-wise comparison
    logic [31:0] bit_eq, bit_gt;
    assign bit_eq = ~(a_i ^ b_i); 
    assign bit_gt = a_i & ~b_i;   

    // Level 1: 4-bit Nibble Comparisons
    logic [7:0] nibble_eq, nibble_gt;
    for (genvar i = 0; i < 8; i++) begin : gen_nibble_comp
        assign nibble_eq[i] = &bit_eq[4*i +: 4];
        assign nibble_gt[i] = bit_gt[4*i+3] | 
                             (bit_eq[4*i+3] & bit_gt[4*i+2]) |
                             (bit_eq[4*i+3] & bit_eq[4*i+2] & bit_gt[4*i+1]) |
                             (bit_eq[4*i+3] & bit_eq[4*i+2] & bit_eq[4*i+1] & bit_gt[4*i+0]);
    end

    // Final Stage: Priority Merge (Optimized for Tool Reachability)
    assign eq_o = &nibble_eq;
    always_comb begin
        casez (nibble_eq)
            8'b0???????: gt_o = nibble_gt[7]; 
            8'b10??????: gt_o = nibble_gt[6]; 
            8'b110?????: gt_o = nibble_gt[5]; 
            8'b1110????: gt_o = nibble_gt[4];
            8'b11110???: gt_o = nibble_gt[3];
            8'b111110??: gt_o = nibble_gt[2];
            8'b1111110?: gt_o = nibble_gt[1];
            8'b11111110: gt_o = nibble_gt[0]; // Force tie-breaker on last nibble
            default:     gt_o = 1'b0;         // Only hit when all equal
        endcase
    end

    assign lt_o = !(gt_o | eq_o);

/* verilator coverage_off */
`ifdef FORMAL
    always_comb begin
        assert(eq_o == (a_i == b_i));
        assert(gt_o == (a_i > b_i));
        assert(lt_o == (a_i < b_i));
        assert($onehot0({gt_o, eq_o, lt_o}));
    end
`endif
/* verilator coverage_on */

endmodule
