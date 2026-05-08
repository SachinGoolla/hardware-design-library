import cocotb
from cocotb.triggers import Timer
import random

@cocotb.test()
async def lean_regression_test(dut):
    """Lean Regression: 10,000 Random Vectors"""
    cocotb.log.info("🎯 Running 10,000 random point regression...")
    
    for i in range(10000):
        val = random.randint(0, 65535)
        dut.data_i.value = val
        await Timer(1, unit="ns")
        
        if val > 0:
            expected_id = (val & -val).bit_length() - 1
            assert int(dut.id_o.value) == expected_id
        else:
            assert int(dut.valid_o.value) == 0

    cocotb.log.info("✅ 10,000 VECTORS PASSED.")
