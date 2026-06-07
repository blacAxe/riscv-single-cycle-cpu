`timescale 1ns/1ps

module tb_cpu_single_cycle;

    reg clk;
    reg reset;

    cpu_single_cycle cpu (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("waves/cpu_single_cycle.vcd");
        $dumpvars(0, tb_cpu_single_cycle);

        clk = 0;
        reset = 1;

        #10;
        reset = 0;

        #100;

        $display("=================================");
        $display("Week 2 CPU Test Results");
        $display("=================================");
        $display("x1  = %d", cpu.rf.registers[1]);
        $display("x2  = %d", cpu.rf.registers[2]);
        $display("x3  = %d", cpu.rf.registers[3]);
        $display("x4  = %d", cpu.rf.registers[4]);
        $display("x5  = %d", cpu.rf.registers[5]);
        $display("mem[0] = %d", cpu.dmem.memory[0]);
        $display("=================================");

        if (
            cpu.rf.registers[1] == 42 &&
            cpu.rf.registers[2] == 42 &&
            cpu.rf.registers[3] == 0 &&
            cpu.rf.registers[4] == 24 &&
            cpu.rf.registers[5] == 7 &&
            cpu.dmem.memory[0] == 42
        ) begin
            $display("PASS: LW, SW, BEQ, and JAL executed correctly.");
        end else begin
            $display("FAIL: CPU state did not match expected results.");
        end

        $finish;
    end

    always #5 clk = ~clk;

endmodule