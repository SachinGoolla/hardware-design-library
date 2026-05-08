import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.clock import Clock
import random

@cocotb.test()
async def ksa_random_test(dut):
    """Test 32-bit KSA with pipeline latency"""
    
    # Use 332ps to clear the 3GHz bar (332 is divisible by 2)
    cocotb.start_soon(Clock(dut.clk_i, 332, units='ps').start())

    # Reset the DUT
    dut.rst_ni.value = 0
    await Timer(1, units="ns")
    dut.rst_ni.value = 1
    
    # Wait for reset to propagate
    await RisingEdge(dut.clk_i)

    for i in range(5000):
        a = random.getrandbits(32)
        b = random.getrandbits(32)
        cin = random.randint(0, 1)

        dut.a_i.value = a
        dut.b_i.value = b
        dut.cin_i.value = cin

        # Pipeline is 2 stages: 
        # 1st Edge: Data enters Stage 1 registers
        # 2nd Edge: Data enters Final Sum registers (Output ready)
        await RisingEdge(dut.clk_i)
        await RisingEdge(dut.clk_i)
        
        # Check on FallingEdge for stability
        await FallingEdge(dut.clk_i)

        expected_sum = (a + b + cin) & 0xFFFFFFFF
        assert dut.sum_o.value == expected_sum, f"Mismatch at iteration {i}: {a} + {b} + {cin}"
