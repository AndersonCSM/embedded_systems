module alu_unit_tb;
    reg [31:0] A, B;
    reg [2:0] ALU_operation;
    wire [31:0] result;
    wire zero;
    
    alu_unit uut(
        .A(A),
        .B(B),
        .ALU_operation(ALU_operation),
        .zero(zero),
        .result(result)
    );
    
    initial begin
        // initialize values
        A <= 32'd200;
        B <= 32'd100;
        // and operation
        ALU_operation <= 0;
        # 20
        // or operation
        ALU_operation <= 1;
        # 20
        // add operation
        ALU_operation <= 2;
        # 20
        // sub operation
        ALU_operation <= 6;
        # 20
        // less than operation
        ALU_operation <= 7;
        # 20
        // nothing
        ALU_operation <= 3;
    end
    
endmodule