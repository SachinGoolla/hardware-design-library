module adder_parameterized #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] a_i,
    input  logic [WIDTH-1:0] b_i,
    input  logic             carry_i,
    output logic [WIDTH-1:0] sum_o,
    output logic             carry_o
);

    // Using a simple concatenation to capture the carry out
    assign {carry_o, sum_o} = a_i + b_i + carry_i;

endmodule
