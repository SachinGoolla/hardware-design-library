import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import random

def to_signed_32(val):
    """Helper to force 32-bit signed bounds in Python"""
    val = val & 0xFFFFFFFF
    return val - 0x100000000 if val & 0x80000000 else val

@cocotb.test()
async def mac_pipeline_test(dut):
    # Start clock
    cocotb.start_soon(Clock(dut.clk_i, 1, units="ns").start())

    # Initialize Inputs
    dut.rst_ni.value = 0
    dut.a_i.value = 0
    dut.b_i.value = 0
    dut.c_i.value = 0
    
    await Timer(2, units="ns")
    dut.rst_ni.value = 1
    await RisingEdge(dut.clk_i)

    # 4-cycle pipeline latency buffer initialized with zeros
    expected_queue = [0, 0, 0, 0]

    # Stress test with 15,000 iterations to comprehensively cover multiplier and adder paths
    for i in range(15000):
        # Randomly assert reset while the pipeline is full of non-zero data!
        if i in [1000, 4000, 7000, 10000]:
            # Special toggle-saturation: Drive all ones before reset
            # This ensures every FF sees a 1 -> 0 transition on reset.
            dut.a_i.value = 0x7FFF
            dut.b_i.value = 0x7FFF
            dut.c_i.value = 0x7FFFFFFF
            await RisingEdge(dut.clk_i)
            await RisingEdge(dut.clk_i) # Fill internal stages with '1's
            
            dut.rst_ni.value = 0
            await RisingEdge(dut.clk_i)
            dut.rst_ni.value = 1
            expected_queue = [0, 0, 0, 0]
            continue

        if i < 12:
            # Directed corner cases: Max/Min bounds and bit toggles
            directed_vectors = [
                (0, 0, 0), (32767, 32767, 2147483647), (-32768, -32768, -2147483648),
                (32767, -32768, 0), (1, 1, -1), (-1, -1, 1), (0, 32767, -1),
                (32767, 0, 2147483647), (-32768, 1, 0), (0x7FFF, 0x7FFF, 0x7FFFFFFF),
                (0x5555, 0xAAAA, 0), (0xAAAA, 0x5555, -1)
            ]
            a, b, c = directed_vectors[i]
        elif i < 2000:
            # Directed tests for the internal Kogge-Stone Adder
            # The adder sums (a * b) and c. By controlling c relative to (a * b),
            # we can force massive carry propagation and toggle patterns.
            a = random.randint(-32768, 32767)
            b = random.randint(-32768, 32767)
            p = (a * b) & 0xFFFFFFFF
            
            pattern = i % 5
            if pattern == 0:
                c_unsigned = (~p) & 0xFFFFFFFF          # Full propagate: P ^ C = 111...1
            elif pattern == 1:
                c_unsigned = ((~p) + 1) & 0xFFFFFFFF    # Full carry ripple
            elif pattern == 2:
                c_unsigned = (0xAAAAAAAA ^ p) & 0xFFFFFFFF # Alternating bit toggles
            elif pattern == 3:
                c_unsigned = (0x55555555 ^ p) & 0xFFFFFFFF # Alternating bit toggles
            else:
                c_unsigned = 0xFFFFFFFF                 # All ones
                
            # Convert unsigned 32-bit pattern back to signed integer for Python/Cocotb
            c = c_unsigned - 0x100000000 if (c_unsigned & 0x80000000) else c_unsigned
        else:
            # Generate full-range random signed 16-bit inputs and 32-bit accumulator
            # This ensures carry-out logic and high-bit transitions are exercised
            a = random.randint(-32768, 32767)
            b = random.randint(-32768, 32767)
            c = random.randint(-2147483648, 2147483647)

        # Drive RTL
        dut.a_i.value = a
        dut.b_i.value = b
        dut.c_i.value = c

        # Calculate Python expected result and queue it
        expected = to_signed_32((a * b) + c)
        expected_queue.append(expected)

        await RisingEdge(dut.clk_i)

        # Pop the oldest expected value (4 cycles ago)
        pop_val = expected_queue.pop(0)
        
        # We only check after the initial reset flush (first 4 cycles)
        if i >= 4:
            actual = dut.mac_o.value.signed_integer
            assert actual == pop_val, f"FAIL at cycle {i}: Expected {pop_val}, got {actual}"

    # Flush the remaining pipeline stages
    for i in range(4):
        await RisingEdge(dut.clk_i)
        pop_val = expected_queue.pop(0)
        actual = dut.mac_o.value.signed_integer
        assert actual == pop_val, f"FAIL on flush {i}: Expected {pop_val}, got {actual}"
        
    dut._log.info("MAC 4-Stage Pipeline Test Passed Perfectly!")
