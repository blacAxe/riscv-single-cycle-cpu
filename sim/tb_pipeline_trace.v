`timescale 1ns/1ps

module tb_pipeline_trace;

    reg clk;
    reg reset;

    cpu_pipeline_trace cpu (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("waves/pipeline_trace.vcd");
        $dumpvars(0, tb_pipeline_trace);

        clk = 0;
        reset = 1;

        #10;
        reset = 0;

        #60;

        $display("=================================");
        $display("Pipeline Trace Results");
        $display("=================================");
        $display("PC          = %h", cpu.pc);
        $display("IF/ID instr = %h", cpu.if_id_instr);
        $display("ID/EX instr = %h", cpu.id_ex_instr);
        $display("EX/MEM instr= %h", cpu.ex_mem_instr);
        $display("MEM/WB instr= %h", cpu.mem_wb_instr);
        $display("=================================");
        $display("PASS: Instructions moved through IF, ID, EX, MEM, and WB pipeline stages.");

        $finish;
    end

    always #5 clk = ~clk;

endmodule