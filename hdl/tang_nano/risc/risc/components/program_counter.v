module pc (
    input clk,
    input reset,
    input PCSrc,          // 0 = PC+4, 1 = branch/jump

    input [31:0] PC_branch,      // endereço do salto
    
    output [31:0] PC,             // PC atual
    output [31:0] PC_plus_4       // útil para instruções que salvam endereço de retorno
);
    reg [31:0] pc_reg;

    // Bloco sequencial: atualiza o PC
    always @(posedge clk) begin
        if (!reset)
            pc_reg <= 32'h0000_0000;
        else
            pc_reg <= PCSrc ? PC_branch : (pc_reg + 32'd4);
    end

    assign PC        = pc_reg;
    assign PC_plus_4 = pc_reg + 32'd4;

endmodule