module cpu_pipeline_trace (
    input clk,
    input reset
);

    reg [31:0] pc;

    wire [31:0] fetched_instr;

    instr_mem imem (
        .addr(pc),
        .instr(fetched_instr)
    );

    reg [31:0] if_id_pc;
    reg [31:0] if_id_instr;

    reg [31:0] id_ex_pc;
    reg [31:0] id_ex_instr;

    reg [31:0] ex_mem_pc;
    reg [31:0] ex_mem_instr;

    reg [31:0] mem_wb_pc;
    reg [31:0] mem_wb_instr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0;

            if_id_pc <= 32'b0;
            if_id_instr <= 32'b0;

            id_ex_pc <= 32'b0;
            id_ex_instr <= 32'b0;

            ex_mem_pc <= 32'b0;
            ex_mem_instr <= 32'b0;

            mem_wb_pc <= 32'b0;
            mem_wb_instr <= 32'b0;
        end else begin
            if_id_pc <= pc;
            if_id_instr <= fetched_instr;

            id_ex_pc <= if_id_pc;
            id_ex_instr <= if_id_instr;

            ex_mem_pc <= id_ex_pc;
            ex_mem_instr <= id_ex_instr;

            mem_wb_pc <= ex_mem_pc;
            mem_wb_instr <= ex_mem_instr;

            pc <= pc + 4;
        end
    end

endmodule