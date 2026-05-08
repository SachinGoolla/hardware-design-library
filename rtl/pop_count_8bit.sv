module pop_count_8bit (
    input  logic [7:0] data_i,
    output logic [3:0] count_o
);
    // We explicitly cast each bit to 4 bits so the linter is happy.
    // This tells the tool: "I am aware I'm adding 1-bit values into a 4-bit bus."
    assign count_o = 4'(data_i[0]) + 4'(data_i[1]) + 4'(data_i[2]) + 4'(data_i[3]) + 
                     4'(data_i[4]) + 4'(data_i[5]) + 4'(data_i[6]) + 4'(data_i[7]);
endmodule
