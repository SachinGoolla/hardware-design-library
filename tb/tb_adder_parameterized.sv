`timescale 1ns/1ps

module tb_adder_parameterized;
    parameter WIDTH = 32;

    logic [WIDTH-1:0] a, b;
    logic             cin;
    wire  [WIDTH-1:0] sum;
    wire              cout;

    // Instantiate the DUT
    adder_parameterized #(.WIDTH(WIDTH)) dut (
        .a_i(a), .b_i(b), .carry_i(cin),
        .sum_o(sum), .carry_o(cout)
    );

    // Cast the 'expected' logic
    logic [WIDTH:0] expected;
    assign expected = (WIDTH+1)'(a) + (WIDTH+1)'(b) + (WIDTH+1)'(cin);

    initial begin
        $dumpfile("../sim/adder_results.vcd");
        $dumpvars(0, tb_adder_parameterized);

        $display("Starting Parameterized Adder Test... Width: %0d", WIDTH);
// --- TOGGLE STRESS BLOCK ---
        // Force every single bit to 0 and 1 to clear Toggle Coverage
        a = {WIDTH{1'b0}}; b = {WIDTH{1'b0}}; cin = 1'b0; #10;
        a = {WIDTH{1'b1}}; b = {WIDTH{1'b1}}; cin = 1'b1; #10;
        a = {WIDTH{1'b0}}; b = {WIDTH{1'b1}}; cin = 1'b0; #10;
        a = {WIDTH{1'b1}}; b = {WIDTH{1'b0}}; cin = 1'b1; #10;
        // --- RANDOM STRESS BLOCK ---
        $display("Running 100,000 Random Vectors...");
        // 100,000 Vector Intensive Run
        repeat(100000) begin
            a = $urandom(); 
            b = $urandom(); 
            cin = 1'($urandom_range(0,1)); 
            #10;
            if ({cout, sum} !== expected) begin
                $display("❌ ERROR: A=%h, B=%h, Cin=%b | Exp=%h, Got=%h", a, b, cin, expected, {cout, sum});
                $finish;
            end
        end

        $display("✅ ALL TESTS PASSED FOR ADDER_PARAMETERIZED");
        $finish;
    end
endmodule
