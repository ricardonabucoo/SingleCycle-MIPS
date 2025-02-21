// Módulo DataMemory corrigido
module DataMemory(
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
    input wire [31:0] address,
    input wire [31:0] writeData,
    output wire [31:0] readData
);
    reg [31:0] memory [255:0];

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'b0;
    end

    assign readData = MemRead ? memory[address[9:2]] : 32'b0;

    always @(posedge clk) begin
        if (MemWrite)
            memory[address[9:2]] <= writeData;
    end
endmodule