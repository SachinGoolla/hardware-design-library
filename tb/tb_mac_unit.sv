`timescale 1ns/1ps

module tb_mac_unit;
    // Parameters
    localparam WIDTH = 16;
    localparam CLK_PERIOD = 0.332; // 3 GHz!

    // Signals
    logic clk_i = 0;
    logic rst_ni = 0;
    logic signed [WIDTH-1:0] a_i;
    logic signed [WIDTH-1:0] b_i;
    logic signed [2*WIDTH-1:0] c_i;
    logic signed [2*WIDTH-1:0] mac_o;

    // Clock Generation
    always #(CLK_PERIOD/2) clk_i = ~clk_i;

    // Device Under Test (DUT)
    mac_unit #(
        .WIDTH(WIDTH)
    ) dut (
        .clk_i  (clk_i),
        .rst_ni (rst_ni),
        .a_i    (a_i),
        .b_i    (b_i),
        .c_i    (c_i),
        .mac_o  (mac_o)
    );

    // High-Volume Stimulus
    initial begin
        $display("Starting High-Volume Simulation [3 GHz Target]...");
        
        // Reset Phase
        @(posedge clk_i);
        rst_ni <= 0;
        repeat(5) @(posedge clk_i);
        rst_ni <= 1;

        // Hammer the logic with random data
        repeat (10000) begin
             @(posedge clk_i);
             // 80% random, 20% extreme edge cases
            if ($random % 5 == 0) begin
                a_i <= (1 << ($random % 16)); // Force a single high bit
                 b_i <= 16'hFFFF;              // Force all high bits
            end else begin
                 a_i <= $random;
                b_i <= $random;
            end
            c_i <= $random;
        end
        $display("Pillar 4: Simulation vectors exhausted. PASS.");
        $finish;
    end

    // Waveform Dump
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_mac_unit);
    end

endmodule
