module instruction_fetch(
    input reset,clk,
    output [31:0] instruction
    );
    
    wire [31:0] PC_address, PC_plus_4;
    
    // instantiate PC
    program_counter program_counter(
        .PC_next(PC_plus_4),
        .clk(clk),
        .reset(reset),
        .PC(PC_address)
    );
    
    // instantiate counter 
    pc_counter pc_counter(
        .PC_address(PC_address),
        .PC_plus_4(PC_plus_4)
        );
        
    // instantiate memory
    instruction_memory instruction_memory(
        .address(PC_address),
        .reset(reset),
        .instruction(instruction)
    );
    
    // initialize memory and PC counter
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            instruction_memory.Memory[i] = i*2;
        end
        program_counter.PC = 0;
    end
    
endmodule