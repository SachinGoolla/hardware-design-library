module tb_comparator_32bit_fast;
    logic [31:0] a_i, b_i;
    
    /* verilator lint_off UNUSEDSIGNAL */
    logic        gt_o, eq_o, lt_o;
    /* verilator lint_on UNUSEDSIGNAL */

    comparator_32bit_fast dut (.*);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_comparator_32bit_fast);

        // 1. DIRECTED: Absolute Equality
        a_i = 32'hFFFF_FFFF; b_i = 32'hFFFF_FFFF; #10;
        
        // 2. DIRECTED: Targeted Nibble Sprints (Walking the 'GT' bit)
        for (int i = 0; i < 8; i++) begin
            a_i = 32'h0; b_i = 32'h0;
            for (int j = 7; j > i; j--) begin
                a_i[j*4 +: 4] = 4'hF;
                b_i[j*4 +: 4] = 4'hF;
            end
            a_i[i*4 +: 4] = 4'hF;
            b_i[i*4 +: 4] = 4'h0;
            #10;
        end

        // 3. VOLUME: Random Stress
        repeat(1000) begin
            a_i = $urandom;
            b_i = $urandom;
            #10;
            if (gt_o !== (a_i > b_i) || eq_o !== (a_i == b_i) || lt_o !== (a_i < b_i)) begin
                $display("FAIL at A=%h, B=%h", a_i, b_i);
                $finish;
            end
        end

        $display("✅ COMPARATOR STRESS TEST COMPLETE.");
        $finish;
    end
endmodule
