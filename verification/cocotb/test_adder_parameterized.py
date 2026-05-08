import cocotb
from cocotb.triggers import Timer
import random

@cocotb.test()
async def test_adder_randomized(dut):
    """Test for parameterized adder with 1000 random samples"""
    
    for i in range(1000):
        # Generate random inputs
        a = random.getrandbits(32)
        b = random.getrandbits(32)
        cin = random.randint(0, 1)

        # Drive the inputs to the DUT
        dut.a_i.value = a
        dut.b_i.value = b
        dut.carry_i.value = cin

        # Wait for combinational logic to settle (Fixed: unit="ns")
        await Timer(1, unit="ns")

        # Calculate Golden Model
        expected = a + b + cin
        
        # Read outputs and cast from 'Logic' to Python 'int'
        actual_carry = int(dut.carry_o.value)
        actual_sum = int(dut.sum_o.value)
        
        # Combine the bits: (carry << 32) OR sum
        actual = (actual_carry << 32) | actual_sum

        # The Self-Check
        assert actual == expected, f"Result mismatch: Got {hex(actual)} != Exp {hex(expected)}"

    dut._log.info("Successfully verified 1000 random vectors!")
