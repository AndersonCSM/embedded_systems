// Tang Nano 1K Blink Example
// LED piscante em 1Hz usando oscilador interno de 27MHz

module top (
    output led
);

    // Oscilador interno de 27MHz
    wire clk;
    wire locked;
    
    Gowin_OSC osc (
        .oscout(clk),
        .locked(locked)
    );

    // Contador para dividir a frequência
    // 27MHz / 27_000_000 = 1Hz
    reg [24:0] counter;
    reg led_out;
    
    always @(posedge clk) begin
        if (counter == 25'd26_999_999) begin
            counter <= 25'd0;
            led_out <= ~led_out;  // Toggle LED
        end else begin
            counter <= counter + 1'b1;
        end
    end
    
    assign led = led_out;

endmodule
