`timescale 1ns/1ps

module tb_pipeline_basic;

    reg clk;
    reg reset;

    cpu_pipeline_basic cpu (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("waves/pipeline_basic.vcd");
        $dumpvars(0, tb_pipeline_basic);

        clk = 0;
        reset = 1;

        #10;
        reset = 0;

        #120;

        $display("=================================");
        $display("Functional Pipeline Results");
        $display("=================================");
        $display("x1 = %d", cpu.rf.registers[1]);
        $display("x2 = %d", cpu.rf.registers[2]);
        $display("x3 = %d", cpu.rf.registers[3]);
        $display("x4 = %d", cpu.rf.registers[4]);
        $display("x5 = %d", cpu.rf.registers[5]);
        $display("=================================");

        if (
            cpu.rf.registers[1] == 5 &&
            cpu.rf.registers[2] == 10 &&
            cpu.rf.registers[3] == 15 &&
            cpu.rf.registers[4] == 20 &&
            cpu.rf.registers[5] == 25
        ) begin
            $display("PASS: Functional pipeline wrote expected register values.");
        end else begin
            $display("FAIL: Functional pipeline register values are incorrect.");
        end

        $finish;
    end

    always #5 clk = ~clk;

endmodule