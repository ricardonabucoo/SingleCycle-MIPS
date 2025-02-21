// Multiplexador 2:1 de 5 bits
module Mux2_5(
    input wire [4:0] in0,
    input wire [4:0] in1,
    input wire sel,
    output wire [4:0] out
);
    assign out = sel ? in1 : in0;
endmodule
