module comparator_generic #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] a_i,
    input  logic [WIDTH-1:0] b_i,
    output logic             eq_o,
    output logic             gt_o,
    output logic             lt_o
);

    assign eq_o = (a_i == b_i);
    assign gt_o = (a_i > b_i);
    assign lt_o = (a_i < b_i);

endmodule
