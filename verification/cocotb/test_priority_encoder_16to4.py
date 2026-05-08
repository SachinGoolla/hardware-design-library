import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def exhaustive_priority_encoder_test(dut):
    """Exhaustively test all 65,536 combinations of the 16:4 Priority Encoder"""
    
    cocotb.log.info("Starting Exhaustive 16-bit LSB Priority Test...")
    
    # Iterate through every possible 16-bit number
    for i in range(65536):
        # Apply input
        dut.data_i.value = i
        
        # Wait for combinatorial logic to settle
        await Timer(1, units="ns")
        
        expected_valid = 1 if i > 0 else 0
        expected_out = 0
        
        if i > 0:
            # LSB Priority Math: Isolate the lowest set bit using Two's Complement
            lowest_set_bit = i & -i
            expected_out = lowest_set_bit.bit_length() - 1
            
        # Assertions
        assert dut.valid_o.value == expected_valid,             f"Valid flag mismatch! Input: {bin(i)}, Expected Valid: {expected_valid}, Got: {dut.valid_o.value}"
            
        if expected_valid:
            assert int(dut.id_o.value) == expected_out,                 f"Encoding mismatch! Input: {bin(i)}, Expected Out: {expected_out}, Got: {int(dut.id_o.value)}"

    cocotb.log.info("✅ ALL 65,536 COMBINATIONS PASSED. Functional Sign-off Complete.")
