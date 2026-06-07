module RISC(
    input clk,
    input reset
);
    
    wire RegDst, RegWrite, ALUsrc, memRead, memWrite, MemToReg,branch, jump;
    wire [5:0] opcode, func;
    wire [2:0] ALUoperation;
    wire [1:0] ALUop;
    
    parameter teste = 1'd0;
    initial begin
        if (teste == 1) begin // Teste R
            dp.instruction_fetch.instruction_memory.Memory[0] = 32'b000000_00000_00001_00010_00000_000010;  
            dp.instruction_fetch.instruction_memory.Memory[1] = 32'b000000_00010_00001_00011_00000_000110; 
            dp.instruction_fetch.instruction_memory.Memory[2] = 32'b000000_00010_00011_00100_00000_000001;  
            dp.instruction_fetch.instruction_memory.Memory[3] = 32'b000000_00011_00100_00101_00000_000000; 
        end
        else if (teste == 2) begin // Teste R e I
            dp.instruction_fetch.instruction_memory.Memory[1] = 32'b000000_00000_00000_0000000000000100; 
            dp.instruction_fetch.instruction_memory.Memory[2] = 32'b000000_00001_00000_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[3] = 32'b000000_00001_00001_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[4] = 32'b000000_00000_00001_00010_00000_000000;
        end
        else if (teste == 3) begin // Teste J
            dp.register_file.Registers[0] = 0;
            dp.register_file.Registers[1] = 0;
            
            dp.instruction_fetch.instruction_memory.Memory[0] = 32'b000000_00000000000000000000010110; 
            dp.instruction_fetch.instruction_memory.Memory[22] = 32'b000000_00000_00001_0000000000000011; 
        end
        else if (teste == 4) begin // Teste Fibonacci
            dp.instruction_fetch.instruction_memory.Memory[1] = 32'b001000_00000_00000_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[2] = 32'b001000_00001_00001_0000000000000001;
            dp.instruction_fetch.instruction_memory.Memory[3] = 32'b001000_11111_11111_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[4] = 32'b101011_11111_00000_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[5] = 32'b001000_11111_11111_0000000000000100;
            dp.instruction_fetch.instruction_memory.Memory[6] = 32'b101011_11111_00001_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[7] = 32'b001000_00011_00011_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[8] = 32'b001000_00100_00100_0000000000011111;
            dp.instruction_fetch.instruction_memory.Memory[9] = 32'b000100_00011_00100_0000000000000111;
            dp.instruction_fetch.instruction_memory.Memory[10] = 32'b000000_00000_00001_00101_00000_100000;
            dp.instruction_fetch.instruction_memory.Memory[11] = 32'b001000_11111_11111_0000000000000100;
            dp.instruction_fetch.instruction_memory.Memory[12] = 32'b101011_11111_00101_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[13] = 32'b001000_00001_00000_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[14] = 32'b001000_00101_00001_0000000000000000;
            dp.instruction_fetch.instruction_memory.Memory[15] = 32'b001000_00011_00011_0000000000000001;
            dp.instruction_fetch.instruction_memory.Memory[16] = 32'b000010_00000000000000000000001001;
        end
    end


    // instantiate Main Control Unit
    control_unit controle(
        .opcode(opcode),
        .RegWrite(RegWrite),  
        .MemToReg(MemToReg), 
        .RegDst(RegDst),
        .ALUsrc(ALUsrc),  
        .branch(branch),   
        .jump(jump), 
        .memWrite(memWrite),  
        .memRead(memRead),
        .ALUop(ALUop)
    );
    
    // instantiate ALU Control Unit
    alu_control alu_controle(
        .ALUop(ALUop),
        .func(func), 
        .ALUoperation(ALUoperation)
    );
    
    // instantiate RISC-v dp
    datapath dp(
        .clk(clk), 
        .reset(reset), 
        .RegDst(RegDst), 
        .RegWrite(RegWrite), 
        .ALUsrc(ALUsrc), 
        .memRead(memRead), 
        .memWrite(memWrite), 
        .MemToReg(MemToReg),
        .branch(branch), 
        .jump(jump),
        .ALUoperation(ALUoperation),
        .opcode(opcode),
        .func(func)
    );

endmodule