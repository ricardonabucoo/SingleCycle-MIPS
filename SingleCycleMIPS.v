`include "ALU.v"
`include "Add4.v"
`include "ControlUnit.v"
`include "DataMemory.v"
`include "MemoriaDeInstrucoes.v"
`include "Mux2_5.v"
`include "Mux2_32.v"
`include "Registradores.v"
`include "ShiftLeft2.v"
`include "SignExtend.v"






module SingleCycleMIPS(
    input wire clk,                
    input wire reset               
);
    // PC e conexões relacionadas
    reg [31:0] pc;                // Valor atual 
    wire [31:0] pc_incrementado;   // Valor incrementado
    wire [31:0] pc_proximo;        // Próximo valor 

    // Instrução e campos
    wire [31:0] instrucao;         // Instrução atual
    wire [5:0] opcode = instrucao[31:26];
    wire [5:0] funct = instrucao[5:0];
    wire [4:0] rs = instrucao[25:21];
    wire [4:0] rt = instrucao[20:16];
    wire [4:0] rd = instrucao[15:11];
    wire [15:0] imediato = instrucao[15:0];
    wire [25:0] jump_address = instrucao[25:0];

    // Extensão de sinal e deslocamento
    wire [31:0] imediato_extendido;
    wire [31:0] imediato_deslocado;
    wire [27:0] jump_shifted;

    // Banco de registradores
    wire [31:0] read_data_1;       // Dados do registrador rs
    wire [31:0] read_data_2;       // Dados do registrador rt
    wire [31:0] write_data;        // Dados a serem escritos
    wire [4:0] write_reg;          // Registrador para escrita

    // ALU e conexões
    wire [31:0] alu_in_b;          // Entrada B da ALU
    wire [31:0] alu_result;        // Resultado da ALU
    wire alu_zero;                 // Sinal zero da ALU

    // Memória de dados
    wire [31:0] read_data_mem;     // Dados lidos da memória

    // Sinais de controle
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, jump;
    wire [3:0] alu_control;

    // PC: Incremento e atualização
    Add4 pc_incrementer(
        .in(pc),
        .out(pc_incrementado)
    );

    // Unidade de controle
    ControlUnit control(
        .opcode(opcode),
        .funct(funct),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );

    // Multiplexador para seleção do registrador de escrita
    Mux2_5 reg_mux(
        .in0(rt),
        .in1(rd),
        .sel(reg_dst),
        .out(write_reg)
    );

    // Banco de registradores
    Registradores regs(
        .clk(clk),
        .ReadRegister1(rs),
        .ReadRegister2(rt),
        .WriteRegister(write_reg),
        .WriteData(write_data),
        .RegWrite(reg_write),
        .ReadData1(read_data_1),
        .ReadData2(read_data_2)
    );

    // Extensão de sinal e deslocamento
    SignExtend sign_extender(
        .in(imediato),
        .out(imediato_extendido)
    );

    ShiftLeft2 shift_left(
        .in(imediato_extendido),
        .out(imediato_deslocado)
    );

    // Multiplexador para seleção da entrada B da ALU
    Mux2_32 alu_mux(
        .in0(read_data_2),
        .in1(imediato_extendido),
        .sel(alu_src),
        .out(alu_in_b)
    );

    // ALU
    ALU alu(
        .A(read_data_1),
        .B(alu_in_b),
        .ALUOperation(alu_control),
        .ALUResult(alu_result),
        .Zero(alu_zero)
    );

    // Memória de dados
    DataMemory data_memory(
        .clk(clk),
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .address(alu_result),
        .writeData(read_data_2),
        .readData(read_data_mem)
    );

    // Multiplexador para seleção dos dados a serem escritos no banco de registradores
    Mux2_32 wb_mux(
        .in0(alu_result),
        .in1(read_data_mem),
        .sel(mem_to_reg),
        .out(write_data)
    );

    // Processamento do endereço de jump
    assign jump_shifted = {jump_address, 2'b00};

    // Cálculo do endereço de branch
    wire [31:0] branch_target = pc_incrementado + imediato_deslocado;
    
    // Seleção do próximo PC
    assign pc_proximo = jump ? {pc_incrementado[31:28], jump_shifted} :
                       (branch && alu_zero) ? branch_target : 
                       pc_incrementado;

    // Atualização do PC
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else
            pc <= pc_proximo;
    end

    // Memória de instruções
    MemoriaDeInstrucoes instr_mem(
        .addr(pc),
        .instrucao(instrucao)
    );
endmodule




