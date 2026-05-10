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

    for i in range(20000):
        # Trigger reset in the middle of operation to hit the reset branch coverage
        if i in [5000, 10000, 15000]:
            # Flood pipeline with 1s to ensure 1->0 toggle on reset
            dut.a_i.value = 0xFFFFFFFF
            dut.b_i.value = 0xFFFFFFFF
            dut.cin_i.value = 1
            await RisingEdge(dut.clk_i)
            await RisingEdge(dut.clk_i)

            dut.rst_ni.value = 0
            await RisingEdge(dut.clk_i)
            dut.rst_ni.value = 1
            continue

        if i < 10:
            # Directed carry-chain patterns to hit the remaining 5% of KSA logic
            vectors = [
                (0xFFFFFFFF, 0x00000000, 1), (0xFFFFFFFF, 0x00000001, 0),
                (0xAAAAAAAA, 0x55555555, 0), (0xAAAAAAAA, 0x55555555, 1),
                (0x00000000, 0x00000000, 0), (0xFFFFFFFF, 0xFFFFFFFF, 1)
            ]
            a, b, cin = vectors[i % len(vectors)]
        elif i < 2000:
            # Deep propagate/generate tests
            a = random.getrandbits(32)
            pattern = i % 4
            if pattern == 0:
                b = (~a) & 0xFFFFFFFF          # Propagate all
            elif pattern == 1:
                b = ((~a) + 1) & 0xFFFFFFFF    # Ripple carry
            elif pattern == 2:
                b = (0xAAAAAAAA ^ a) & 0xFFFFFFFF # Alternating bits
            else:
                b = 0xFFFFFFFF
            cin = random.randint(0, 1)
        else:
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
