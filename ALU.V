// Módulo ALU para operações aritméticas e lógicas
module ALU(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] ALUOperation,
    output reg [31:0] ALUResult,
    output wire Zero
);
    always @(*) begin
        case (ALUOperation)
            4'b0000: ALUResult = A & B;          // AND
            4'b0001: ALUResult = A | B;          // OR
            4'b0010: ALUResult = A + B;          // ADD
            4'b0110: ALUResult = A - B;          // SUB
            4'b0111: ALUResult = (A < B) ? 1 : 0; // SLT
            4'b1100: ALUResult = ~(A | B);       // NOR
            default: ALUResult = 32'b0;
        endcase
    end
    
    assign Zero = (ALUResult == 32'b0);
endmodule