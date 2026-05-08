module decoder_generic #(
    parameter DEC_WIDTH = 3
)(
    input  logic [DEC_WIDTH-1:0] sel_i,
    output logic [(1<<DEC_WIDTH)-1:0] out_o
);
    assign out_o = (1 << sel_i);
endmodule
