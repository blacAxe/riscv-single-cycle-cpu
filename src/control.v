module control (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg jump,
    output reg alu_src,
    output reg mem_to_reg,
    output reg [3:0] alu_control
);

    always @(*) begin
        reg_write   = 0;
        mem_read    = 0;
        mem_write   = 0;
        branch      = 0;
        jump        = 0;
        alu_src     = 0;
        mem_to_reg  = 0;
        alu_control = 4'b0000;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1;
                alu_src = 0;

                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_control = 4'b0000; // ADD
                    {7'b0100000, 3'b000}: alu_control = 4'b0001; // SUB
                    {7'b0000000, 3'b111}: alu_control = 4'b0010; // AND
                    {7'b0000000, 3'b110}: alu_control = 4'b0011; // OR
                    {7'b0000000, 3'b100}: alu_control = 4'b0100; // XOR
                    default: alu_control = 4'b0000;
                endcase
            end

            7'b0010011: begin // ADDI
                reg_write = 1;
                alu_src = 1;
                alu_control = 4'b0000;
            end

            7'b0000011: begin // LW
                reg_write = 1;
                mem_read = 1;
                alu_src = 1;
                mem_to_reg = 1;
                alu_control = 4'b0000;
            end

            7'b0100011: begin // SW
                mem_write = 1;
                alu_src = 1;
                alu_control = 4'b0000;
            end

            7'b1100011: begin // BEQ
                branch = 1;
                alu_src = 0;
                alu_control = 4'b0001;
            end

            7'b1101111: begin // JAL
                reg_write = 1;
                jump = 1;
            end
        endcase
    end

endmodule