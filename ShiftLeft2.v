// Módulo ShiftLeft2 para deslocamento
module ShiftLeft2(
    input wire [31:0] in,
    output wire [31:0] out
);
    assign out = in << 2;
endmodule
