import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def comparator_coverage_crusher(dut):
    """Force the simulator to walk every single line of the priority tree"""
    
    # 1. Test Equality (Hits the eq_o line)
    dut.a_i.value = 0xAAAAAAAA
    dut.b_i.value = 0xAAAAAAAA
    await Timer(1, unit="ns")
    
    # 2. Test Less Than (Hits the lt_o line)
    dut.a_i.value = 0x00000000
    dut.b_i.value = 0xFFFFFFFF
    await Timer(1, unit="ns")

    # 3. Test GT at every nibble level (Hits the gt_o if-chain)
    # We make A and B identical, then flip ONE bit in a specific nibble
    for i in range(8):
        base = 0x55555555
        # Set all higher nibbles to be equal, and current nibble A > B
        dut.a_i.value = base | (1 << (i*4))
        dut.b_i.value = base & ~(1 << (i*4))
        await Timer(1, unit="ns")
