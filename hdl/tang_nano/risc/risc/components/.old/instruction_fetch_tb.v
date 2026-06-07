module instruction_fetch_tb;
    reg clk, reset;
    wire [31:0] instruction;
    
    // instantiate instruction fetch unit
    instruction_fetch uut(
        .reset(reset),
        .clk(clk),
        .instruction(instruction)
        );
        
    initial begin
        clk <= 0;
        reset <= 0;
        #10
        reset <= 1;        
    end
    always #50 clk = ~clk;
endmodule