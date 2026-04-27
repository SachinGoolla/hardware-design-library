module comparator_32b #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] a_i,
    input  logic [WIDTH-1:0] b_i,
    output logic             gt_o,
    output logic             eq_o
);

    // Production-grade processors use bit-wise XOR to check equality 
    // and a prefix-tree for magnitude to minimize gate depth.
    
    assign eq_o = (a_i == b_i);
    assign gt_o = (a_i > b_i); // Yosys will map this to a tree-structure in 45nm

endmodule
