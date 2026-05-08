module tb_adder_ksa_32bit;
    logic clk_i = 0;
    logic rst_ni;
    logic [31:0] a_i, b_i;
    logic        cin_i;
    logic [31:0] sum_o;
    
    /* verilator lint_off UNUSEDSIGNAL */
    logic        cout_o; 
    /* verilator lint_on UNUSEDSIGNAL */

    adder_ksa_32bit dut (.*);

    // Clock generation
    always #166 clk_i = ~clk_i; 

    initial begin
        // Force the waveform file to be created right here
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_adder_ksa_32bit);

        rst_ni = 0;
        a_i = 0; b_i = 0; cin_i = 0;
        #1000 rst_ni = 1;
        
        // REDUCED TO 100 TO STOP THE CRASH
        repeat(100) begin
            @(posedge clk_i);
            a_i = $urandom;
            b_i = $urandom;
            cin_i = 1'($urandom_range(0,1));
            
            repeat(2) @(posedge clk_i); 
            
            #10; 
            if (sum_o !== (a_i + b_i + 32'(cin_i))) begin
                $display("FAIL! %d + %d + %d != %d", a_i, b_i, cin_i, sum_o);
                $finish;
            end
        end
        $display("✅ KSA STRESS TEST COMPLETE.");
        $finish;
    end
endmodule
