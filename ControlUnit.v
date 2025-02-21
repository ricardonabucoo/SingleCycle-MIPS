///tentei adotar um padrão de organização bem certinho e o mais clean possível
module ControlUnit(
    input wire [5:0] opcode,
    input wire [5:0] funct,
    output reg reg_dst,
    output reg alu_src,
    output reg mem_to_reg,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg jump,
    output reg [3:0] alu_control
);
    // Definição dos opcodes
    parameter R_TYPE = 6'b000000;
    parameter LW     = 6'b100011;
    parameter SW     = 6'b101011;
    parameter BEQ    = 6'b000100;
    parameter J      = 6'b000010;
    parameter ADDI   = 6'b001000;

    // Definição dos function codes (R-type)
    parameter ADD = 6'b100000;
    parameter SUB = 6'b100010;
    parameter AND = 6'b100100;
    parameter OR  = 6'b100101;
    parameter SLT = 6'b101010;
    ///sugestão de organização para deixar legivel e não me perder.
    always @(*) begin
        // Valores default
        reg_dst = 0;
        alu_src = 0;
        mem_to_reg = 0;
        reg_write = 0;
        mem_read = 0;
        mem_write = 0;
        branch = 0;
        jump = 0;
        alu_control = 4'b0000;

        case (opcode)
            R_TYPE: begin
                reg_dst = 1;
                reg_write = 1;
                case (funct)
                    ADD: alu_control = 4'b0010;
                    SUB: alu_control = 4'b0110;
                    AND: alu_control = 4'b0000;
                    OR:  alu_control = 4'b0001;
                    SLT: alu_control = 4'b0111;
                    default: alu_control = 4'b0000;
                endcase
            end
            
            LW: begin
                alu_src = 1;
                mem_to_reg = 1;
                reg_write = 1;
                mem_read = 1;
                alu_control = 4'b0010;  // ADD
            end
            
            SW: begin
                alu_src = 1;
                mem_write = 1;
                alu_control = 4'b0010;  // ADD
            end
            
            BEQ: begin
                branch = 1;
                alu_control = 4'b0110;  // SUB
            end
            
            J: begin
                jump = 1;
            end
            
            ADDI: begin
                alu_src = 1;
                reg_write = 1;
                alu_control = 4'b0010;  // ADD
            end
            
            default: begin
                
            end
        endcase
    end
endmodule