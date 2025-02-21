
`include "SingleCycleMIPS.v"
module TestBenchMIPS;
    reg clk;
    reg reset;

    SingleCycleMIPS mips(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("mips.vcd");
        $dumpvars(0, TestBenchMIPS);

        reset = 1;
        #20;
        reset = 0;

        
        #400;

        
        $display("\n=== Final State of Registers ===");
        $display("$t0 (R8):  %h (%d)", mips.regs.registers[8], $signed(mips.regs.registers[8]));
        $display("$t1 (R9):  %h (%d)", mips.regs.registers[9], $signed(mips.regs.registers[9]));
        $display("$t2 (R10): %h (%d)", mips.regs.registers[10], $signed(mips.regs.registers[10]));
        $display("$t3 (R11): %h (%d)", mips.regs.registers[11], $signed(mips.regs.registers[11]));
        $display("$t4 (R12): %h (%d)", mips.regs.registers[12], $signed(mips.regs.registers[12]));
        $display("$t5 (R13): %h (%d)", mips.regs.registers[13], $signed(mips.regs.registers[13]));
        
        $display("\n=== Memory Content ===");
        $display("Mem[0]: %h (%d)", mips.data_memory.memory[0], $signed(mips.data_memory.memory[0]));
        
        $finish;
    end

    // Monitor de execução 
    always @(posedge clk) begin
        if (!reset) begin
            $display("\nTime=%0t PC=%h", $time, mips.pc);
            $display("Instruction=%h", mips.instrucao);
            case(mips.opcode)
                6'b000000: begin // R-type
                    case(mips.funct)
                        6'b100000: $display("ADD $%d, $%d, $%d", mips.rd, mips.rs, mips.rt);
                        6'b100010: $display("SUB $%d, $%d, $%d", mips.rd, mips.rs, mips.rt);
                        6'b100100: $display("AND $%d, $%d, $%d", mips.rd, mips.rs, mips.rt);
                        6'b100101: $display("OR $%d, $%d, $%d", mips.rd, mips.rs, mips.rt);
                        6'b101010: $display("SLT $%d, $%d, $%d", mips.rd, mips.rs, mips.rt);
                    endcase
                end
                6'b100011: $display("LW $%d, %d($%d)", mips.rt, $signed(mips.imediato), mips.rs);
                6'b101011: $display("SW $%d, %d($%d)", mips.rt, $signed(mips.imediato), mips.rs);
                6'b000100: $display("BEQ $%d, $%d, %d", mips.rs, mips.rt, $signed(mips.imediato));
                6'b001000: $display("ADDI $%d, $%d, %d", mips.rt, mips.rs, $signed(mips.imediato));
                6'b000010: $display("J %d", mips.jump_address);
            endcase
            $display("ALU Result=%h", mips.alu_result);
        end
    end
endmodule