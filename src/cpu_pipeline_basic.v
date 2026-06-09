module cpu_pipeline_basic (
    input clk,
    input reset
);

    reg [31:0] pc;

    wire [31:0] fetched_instr;

    instr_mem_pipeline imem (
        .addr(pc),
        .instr(fetched_instr)
    );

    // =========================
    // IF / ID pipeline register
    // =========================
    reg [31:0] if_id_pc;
    reg [31:0] if_id_instr;

    // =========================
    // Decode wires
    // =========================
    wire [6:0] id_opcode = if_id_instr[6:0];
    wire [4:0] id_rd     = if_id_instr[11:7];
    wire [2:0] id_funct3 = if_id_instr[14:12];
    wire [4:0] id_rs1    = if_id_instr[19:15];
    wire [4:0] id_rs2    = if_id_instr[24:20];
    wire [6:0] id_funct7 = if_id_instr[31:25];

    wire id_reg_write;
    wire id_mem_read;
    wire id_mem_write;
    wire id_branch;
    wire id_jump;
    wire id_alu_src;
    wire id_mem_to_reg;
    wire [3:0] id_alu_control;

    wire [31:0] id_read_data1;
    wire [31:0] id_read_data2;
    wire [31:0] id_imm;

    // =========================
    // WB wires
    // =========================
    wire wb_reg_write;
    wire [4:0] wb_rd;
    wire [31:0] wb_write_data;

    control ctrl (
        .opcode(id_opcode),
        .funct3(id_funct3),
        .funct7(id_funct7),
        .reg_write(id_reg_write),
        .mem_read(id_mem_read),
        .mem_write(id_mem_write),
        .branch(id_branch),
        .jump(id_jump),
        .alu_src(id_alu_src),
        .mem_to_reg(id_mem_to_reg),
        .alu_control(id_alu_control)
    );

    regfile rf (
        .clk(clk),
        .reg_write(wb_reg_write),
        .rs1(id_rs1),
        .rs2(id_rs2),
        .rd(wb_rd),
        .write_data(wb_write_data),
        .read_data1(id_read_data1),
        .read_data2(id_read_data2)
    );

    imm_gen ig (
        .instr(if_id_instr),
        .imm(id_imm)
    );

    // =========================
    // ID / EX pipeline register
    // =========================
    reg [31:0] id_ex_pc;
    reg [31:0] id_ex_read_data1;
    reg [31:0] id_ex_read_data2;
    reg [31:0] id_ex_imm;
    reg [4:0]  id_ex_rd;

    reg id_ex_reg_write;
    reg id_ex_mem_read;
    reg id_ex_mem_write;
    reg id_ex_alu_src;
    reg id_ex_mem_to_reg;
    reg [3:0] id_ex_alu_control;

    // =========================
    // Execute stage
    // =========================
    wire [31:0] ex_alu_b;
    wire [31:0] ex_alu_result;
    wire ex_zero;

    assign ex_alu_b = id_ex_alu_src ? id_ex_imm : id_ex_read_data2;

    alu alu_unit (
        .a(id_ex_read_data1),
        .b(ex_alu_b),
        .alu_control(id_ex_alu_control),
        .result(ex_alu_result),
        .zero(ex_zero)
    );

    // =========================
    // EX / MEM pipeline register
    // =========================
    reg [31:0] ex_mem_alu_result;
    reg [31:0] ex_mem_write_data;
    reg [4:0]  ex_mem_rd;

    reg ex_mem_reg_write;
    reg ex_mem_mem_read;
    reg ex_mem_mem_write;
    reg ex_mem_mem_to_reg;

    // =========================
    // Memory stage
    // =========================
    wire [31:0] mem_read_data;

    data_mem dmem (
        .clk(clk),
        .mem_read(ex_mem_mem_read),
        .mem_write(ex_mem_mem_write),
        .addr(ex_mem_alu_result),
        .write_data(ex_mem_write_data),
        .read_data(mem_read_data)
    );

    // =========================
    // MEM / WB pipeline register
    // =========================
    reg [31:0] mem_wb_alu_result;
    reg [31:0] mem_wb_read_data;
    reg [4:0]  mem_wb_rd;

    reg mem_wb_reg_write;
    reg mem_wb_mem_to_reg;

    assign wb_reg_write = mem_wb_reg_write;
    assign wb_rd = mem_wb_rd;
    assign wb_write_data = mem_wb_mem_to_reg ? mem_wb_read_data : mem_wb_alu_result;

    // =========================
    // Pipeline register updates
    // =========================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0;

            if_id_pc <= 32'b0;
            if_id_instr <= 32'b0;

            id_ex_pc <= 32'b0;
            id_ex_read_data1 <= 32'b0;
            id_ex_read_data2 <= 32'b0;
            id_ex_imm <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_reg_write <= 1'b0;
            id_ex_mem_read <= 1'b0;
            id_ex_mem_write <= 1'b0;
            id_ex_alu_src <= 1'b0;
            id_ex_mem_to_reg <= 1'b0;
            id_ex_alu_control <= 4'b0;

            ex_mem_alu_result <= 32'b0;
            ex_mem_write_data <= 32'b0;
            ex_mem_rd <= 5'b0;
            ex_mem_reg_write <= 1'b0;
            ex_mem_mem_read <= 1'b0;
            ex_mem_mem_write <= 1'b0;
            ex_mem_mem_to_reg <= 1'b0;

            mem_wb_alu_result <= 32'b0;
            mem_wb_read_data <= 32'b0;
            mem_wb_rd <= 5'b0;
            mem_wb_reg_write <= 1'b0;
            mem_wb_mem_to_reg <= 1'b0;
        end else begin
            // IF
            if_id_pc <= pc;
            if_id_instr <= fetched_instr;
            pc <= pc + 4;

            // ID
            id_ex_pc <= if_id_pc;
            id_ex_read_data1 <= id_read_data1;
            id_ex_read_data2 <= id_read_data2;
            id_ex_imm <= id_imm;
            id_ex_rd <= id_rd;
            id_ex_reg_write <= id_reg_write;
            id_ex_mem_read <= id_mem_read;
            id_ex_mem_write <= id_mem_write;
            id_ex_alu_src <= id_alu_src;
            id_ex_mem_to_reg <= id_mem_to_reg;
            id_ex_alu_control <= id_alu_control;

            // EX
            ex_mem_alu_result <= ex_alu_result;
            ex_mem_write_data <= id_ex_read_data2;
            ex_mem_rd <= id_ex_rd;
            ex_mem_reg_write <= id_ex_reg_write;
            ex_mem_mem_read <= id_ex_mem_read;
            ex_mem_mem_write <= id_ex_mem_write;
            ex_mem_mem_to_reg <= id_ex_mem_to_reg;

            // MEM
            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_read_data <= mem_read_data;
            mem_wb_rd <= ex_mem_rd;
            mem_wb_reg_write <= ex_mem_reg_write;
            mem_wb_mem_to_reg <= ex_mem_mem_to_reg;
        end
    end

endmodule