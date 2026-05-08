module mac_unit #(
    parameter WIDTH = 16
)(
    input  clk,
    input  rst_n,
    input  [WIDTH-1:0] a_i,
    input  [WIDTH-1:0] b_i,
    input  [2*WIDTH:0] c_i, // Accumulator input
    output reg [2*WIDTH:0] mac_o
);
    // Pipelined for 3GHz targets
    wire [2*WIDTH-1:0] mult_res;
    assign mult_res = a_i * b_i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mac_o <= 0;
        else
            mac_o <= mult_res + c_i;
    end
endmodule
