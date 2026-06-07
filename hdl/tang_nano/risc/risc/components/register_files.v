module register_file(
    input [4:0] register_read_1,
    input [4:0] register_read_2,
    input [4:0] write_register,

    input [31:0] write_data,

    input reg_write, reg_clk, reset,

    output [31:0] read_data_1,
    output [31:0] read_data_2
);

reg [31:0] Registers [31:0];

assign read_data_1 = (!reset)? 32'h00000000  : Registers[register_read_1];
assign read_data_2 = (!reset)? 32'h00000000  : Registers[register_read_2];

always @(posedge reg_clk) begin
    $display("Writing to register %d: %d, %d", write_register, write_data,reg_write);
    
    if( reg_write == 1'b1 ) begin
        Registers[write_register] <= write_data;
    end
end

endmodule