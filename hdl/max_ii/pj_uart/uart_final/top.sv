module top ()
    baud_generate baud_gen (
        .clk(clk),
        .rst(rst),
        .baud_rate(baud_rate),
        .tick_rate(tick_rate)
    );

    rx rx_instance (
        .clk(clk),
        .rst(rst),
        .en_rx(en_rx),
        .tick_rate(tick_rate),  // ← usa o sinal gerado por baud_generate
        .data_in(data_in),
        .data_out(data_out),
        .done_rx(done_rx),
        .parity_error(parity_error)
    );

// gerador de baud_rate
// divisor de clock
// rx
// tx
// buffer input
// buffer out
// display 7 segmentos
// outros: tx fifo, tx shifter, tx flow control,
// rx flow control, rx fifo, rs shifter, clock generatior, dma controller
// csr interface
endmodule