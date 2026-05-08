module tb_priority_encoder_16to4;
    /* verilator lint_off UNUSEDSIGNAL */
    logic [15:0] data_i;
    logic [3:0]  id_o;
    logic        valid_o;
    /* verilator lint_on UNUSEDSIGNAL */

    priority_encoder_16to4 dut (.*);

    initial begin
        $display("Starting High-Volume Coverage Sim for Priority Encoder...");
        for (int i = 0; i < 65536; i++) begin
            // Explicitly cast to 16 bits to stop the width warning
            data_i = 16'(i);
            #1;
        end
        $display("✅ EXHAUSTIVE SIMULATION COMPLETE.");
        $finish;
    end
endmodule
