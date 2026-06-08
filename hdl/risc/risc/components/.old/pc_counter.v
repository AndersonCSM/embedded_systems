module pc_counter(
    input [31:0] PC_address,

    output [31: 0] PC_plus_4
);

// incrementa o endereço atual em 4
    assign PC_plus_4 = PC_address + 32'd4;

endmodule