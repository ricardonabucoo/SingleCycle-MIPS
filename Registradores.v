// Módulo Registradores corrigido
module Registradores(
    input wire clk,
    input wire [4:0] ReadRegister1,
    input wire [4:0] ReadRegister2,
    input wire [4:0] WriteRegister,
    input wire [31:0] WriteData,
    input wire RegWrite,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2
);
    reg [31:0] registers [31:0];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    assign ReadData1 = registers[ReadRegister1];
    assign ReadData2 = registers[ReadRegister2];

    always @(posedge clk) begin
        if (RegWrite && WriteRegister != 5'b0)
            registers[WriteRegister] <= WriteData;
    end
endmodule