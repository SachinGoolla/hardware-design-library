module mux_4to1 #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] a_i,
    input  logic [WIDTH-1:0] b_i,
    input  logic [WIDTH-1:0] c_i,
    input  logic [WIDTH-1:0] d_i,
    input  logic [1:0]       sel_i,
    output logic [WIDTH-1:0] data_o
);

    always_comb begin
        case (sel_i)
            2'b00:   data_o = a_i;
            2'b01:   data_o = b_i;
            2'b10:   data_o = c_i;
            2'b11:   data_o = d_i;
            default: data_o = {WIDTH{1'b0}};
        endcase
    end

endmodule
