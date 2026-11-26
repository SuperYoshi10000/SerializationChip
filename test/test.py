# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer


@cocotb.test()
async def test_project(dut):
    await setup_test(dut, "Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Wait for one clock cycle to see the output values
    await Timer(2)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 0

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.

# @cocotb.test()
async def test_parallel_to_serial(dut):
    await setup_test(dut, "Test parallel to serial")

    dut.uio_in.value = 0b11001010

    await Timer(2)
    assert dut.uo_out.value == 0b0
    # assert dut.uio_out.value == 0b00000000
    dut._log.info("uio out = " + dut.uio_out.value.binstr)

    await Timer(2)
    assert dut.uo_out.value == 0b1
    # assert dut.uio_out.value == 0b00010000
    dut._log.info("uio out = " + dut.uio_out.value.binstr)

    await Timer(2)
    assert dut.uo_out.value == 0b0
    assert dut.uio_out.value == 0b00100000

    await Timer(2)
    assert dut.uo_out.value == 0b1
    assert dut.uio_out.value == 0b00110000

    await Timer(2)
    assert dut.uo_out.value == 0b0
    assert dut.uio_out.value == 0b01000000
    
    await Timer(2)
    assert dut.uo_out.value == 0b0
    assert dut.uio_out.value == 0b01010000
    
    await Timer(2)
    assert dut.uo_out.value == 0b1
    assert dut.uio_out.value == 0b01100000
    
    await Timer(2)
    assert dut.uo_out.value == 0b1
    assert dut.uio_out.value == 0b11110000

# @cocotb.test()
async def test_serial_to_parallel(dut):
    await setup_test(dut, "Test serial to parallel")

    dut.uio_in.value = 0b1
    
    dut.ui_in.value = 0b11
    await Timer(2)
    assert dut.uo_out.value == 0b00000001
    assert dut.uio_out.value == 0b00000000

    dut.ui_in.value = 0b01
    await Timer(2)
    assert dut.uo_out.value == 0b00000001
    assert dut.uio_out.value == 0b00010000

    dut.ui_in.value = 0b10
    await Timer(2)
    assert dut.uo_out.value == 0b00000001
    assert dut.uio_out.value == 0b00100000

    dut.ui_in.value = 0b11
    await Timer(2)
    assert dut.uo_out.value == 0b00001001
    assert dut.uio_out.value == 0b00110000

    dut.ui_in.value = 0b00
    await Timer(6)
    assert dut.uo_out.value == 0b00001001
    assert dut.uio_out.value == 0b11110000
    
    dut.ui_in.value = 0b10
    await Timer(2)
    assert dut.uo_out.value == 0b00001000
    assert dut.uio_out.value == 0b00000000

    dut.ui_in.value = 0b11
    await Timer(9)
    assert dut.uo_out.value == 0b00011110
    assert dut.uio_out.value == 0b01000000


async def setup_test(dut, msg = "Test", period = 2):
    dut._log.info("Start")
    
    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, period)
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await Timer(1)
    dut.rst_n.value = 1

    dut._log.info(msg)