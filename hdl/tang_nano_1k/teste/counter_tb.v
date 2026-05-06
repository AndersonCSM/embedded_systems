// Testbench para counter.v - Teste de LED Toggle

`timescale 1ns/1ps

module counter_tb;

    // Signals
    reg sys_clk;
    reg sys_rst_n;
    wire led;

    // Internal signals to monitor counter
    integer cycle_count = 0;
    integer toggle_count = 0;
    reg last_led = 1'b1;

    // Instantiate the module under test
    top dut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .led(led)
    );

    // Clock generation (27MHz = ~37ns period)
    initial begin
        sys_clk = 0;
        forever #18.5 sys_clk = ~sys_clk;  // 27MHz clock
    end

    // Test sequence
    initial begin
        // VCD dump for visualization
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);

        // Initialize
        sys_rst_n = 0;
        #100 sys_rst_n = 1;  // Release reset

        $display("\n=== Counter.v Testbench ===");
        $display("Testing LED toggle at 0.5s intervals (27MHz clock)");
        $display("Expected: LED toggles every 13,500,000 clock cycles");
        $display("Time          | Cycles | LED");
        $display("-----------------------------------");

        // Simulate for long enough to see multiple toggles
        // 13.5M cycles * 37ns = 499.5ms per toggle
        // Run for ~1.5 seconds to see 3 toggles
        #30000000;

        $display("\n=== Simulation Complete ===");
        $display("Total toggles detected: %0d", toggle_count);
        $finish;
    end

    // Monitor LED changes
    always @(posedge sys_clk) begin
        cycle_count = cycle_count + 1;
        
        if (led != last_led) begin
            toggle_count = toggle_count + 1;
            $display("Time: %0d ns | Cycle: %0d | LED: %b -> %b", $time, cycle_count, last_led, led);
            last_led = led;
        end
        
        // Print status every 1M cycles
        if (cycle_count % 1000000 == 0) begin
            $display("Time: %0d ns | Cycles: %0dM | LED: %b", $time, cycle_count/1000000, led);
        end
    end

endmodule
