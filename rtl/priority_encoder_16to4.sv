module priority_encoder_16to4 (
    input  logic [15:0] data_i,
    output logic [3:0]  id_o,
    output logic        valid_o
);
    // PILLAR 1/3/4/5: Your high-performance parallel tree
    logic v0, v1, v2, v3;
    assign v0 = |data_i[3:0];
    assign v1 = |data_i[7:4];
    assign v2 = |data_i[11:8];
    assign v3 = |data_i[15:12];
    assign valid_o = v0 | v1 | v2 | v3;

    logic [1:0] id0, id1, id2, id3;
    assign id0 = data_i[0] ? 2'b00 : data_i[1] ? 2'b01 : data_i[2] ? 2'b10 : 2'b11;
    assign id1 = data_i[4] ? 2'b00 : data_i[5] ? 2'b01 : data_i[6] ? 2'b10 : 2'b11;
    assign id2 = data_i[8] ? 2'b00 : data_i[9] ? 2'b01 : data_i[10] ? 2'b10 : 2'b11;
    assign id3 = data_i[12] ? 2'b00 : data_i[13] ? 2'b01 : data_i[14] ? 2'b10 : 2'b11;

    always_comb begin
        if      (v0) id_o = {2'b00, id0};
        else if (v1) id_o = {2'b01, id1};
        else if (v2) id_o = {2'b10, id2};
        else         id_o = {2'b11, id3};
    end

`ifdef FORMAL
    // PILLAR 2: The "Golden Model" check
    // Casez is a mathematical 'Look-Up Table' - Z3 solves this instantly.
    logic [3:0] id_expected;
    always_comb begin
        casez (data_i)
            16'b???????????????1: id_expected = 4'd0;
            16'b??????????????10: id_expected = 4'd1;
            16'b?????????????100: id_expected = 4'd2;
            16'b????????????1000: id_expected = 4'd3;
            16'b???????????10000: id_expected = 4'd4;
            16'b??????????100000: id_expected = 4'd5;
            16'b?????????1000000: id_expected = 4'd6;
            16'b????????10000000: id_expected = 4'd7;
            16'b???????100000000: id_expected = 4'd8;
            16'b??????1000000000: id_expected = 4'd9;
            16'b?????10000000000: id_expected = 4'd10;
            16'b????100000000000: id_expected = 4'd11;
            16'b???1000000000000: id_expected = 4'd12;
            16'b??10000000000000: id_expected = 4'd13;
            16'b?100000000000000: id_expected = 4'd14;
            16'b1000000000000000: id_expected = 4'd15;
            default:              id_expected = 4'd0;
        endcase

        // Single, atomic assertion
        if (valid_o) assert(id_o == id_expected);
        assert(valid_o == (|data_i));
    end
`endif
endmodule
