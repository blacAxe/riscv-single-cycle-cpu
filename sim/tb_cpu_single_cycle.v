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

        #80;;

        $display("Register x1 = %d", cpu.rf.registers[1]);
        $display("Register x2 = %d", cpu.rf.registers[2]);
        $display("Register x3 = %d", cpu.rf.registers[3]);
        $display("Register x4 = %d", cpu.rf.registers[4]);
        $display("Register x5 = %d", cpu.rf.registers[5]);

        $finish;
    end

    always #5 clk = ~clk;

endmodule