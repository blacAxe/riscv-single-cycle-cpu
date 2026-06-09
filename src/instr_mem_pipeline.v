module instr_mem_pipeline (
    input [31:0] addr,
    output [31:0] instr
);

    reg [31:0] memory [0:255];

    initial begin
        $readmemh("programs/pipeline_basic.hex", memory);
    end

    assign instr = memory[addr[31:2]];

endmodule