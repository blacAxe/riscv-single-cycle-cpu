module cpu_single_cycle (
    input clk,
    input reset
);

    reg [31:0] pc;

    wire [31:0] instr;
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [6:0] funct7 = instr[31:25];

    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire branch;
    wire jump;
    wire alu_src;
    wire mem_to_reg;
    wire [3:0] alu_control;

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] imm;
    wire [31:0] alu_b;
    wire [31:0] alu_result;
    wire zero;
    wire [31:0] mem_data;
    wire [31:0] write_back_data;

    instr_mem imem (
        .addr(pc),
        .instr(instr)
    );

    control ctrl (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .alu_control(alu_control)
    );

    regfile rf (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    imm_gen ig (
        .instr(instr),
        .imm(imm)
    );

    assign alu_b = alu_src ? imm : read_data2;

    alu alu_unit (
        .a(read_data1),
        .b(alu_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    data_mem dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .write_data(read_data2),
        .read_data(mem_data)
    );

    assign write_back_data = jump ? (pc + 4) :
                             mem_to_reg ? mem_data :
                             alu_result;

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else if (jump)
            pc <= pc + imm;
        else if (branch && zero)
            pc <= pc + imm;
        else
            pc <= pc + 4;
    end

endmodule