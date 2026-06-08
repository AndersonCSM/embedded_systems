module program_counter (
    input [31:0] PC_next,
    input clk, reset,

    output reg[31:0] PC
);

always @(posedge clk) begin
    PC <= (reset == 1'b0)? 32'h00000000 : PC_next;
end

endmodule