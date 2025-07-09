`timescale 1ns / 1ps

module Traffic_4Way_Controller_tb;

    // Inputs
    reg CLK;
    reg RESET;

    // Outputs
    wire NS_RED, NS_YELLOW, NS_GREEN;
    wire EW_RED, EW_YELLOW, EW_GREEN;
    wire [4:0] timer;

    // Instantiate the DUT (Device Under Test)
    Traffic_4Way_Controller uut (
        .CLK(CLK),
        .RESET(RESET),
        .NS_RED(NS_RED),
        .NS_YELLOW(NS_YELLOW),
        .NS_GREEN(NS_GREEN),
        .EW_RED(EW_RED),
        .EW_YELLOW(EW_YELLOW),
        .EW_GREEN(EW_GREEN),
        .timer(timer)
        );

    // Clock generation: 10ns period (100 MHz)
    initial CLK = 0;
    always #5 CLK = ~CLK;

    // Simulation control
    initial begin
        $display("Starting 4-Way Traffic Light Controller Simulation...");
        $monitor("Time=%0t | NS: R=%b Y=%b G=%b | EW: R=%b Y=%b G=%b",
                 $time, NS_RED, NS_YELLOW, NS_GREEN, EW_RED, EW_YELLOW, EW_GREEN);

        // Initial values
        RESET = 1;
        #20;
        RESET = 0;

        // Let simulation run long enough to see all states
        #1000;

        $display("Simulation Ended.");
        $finish;
    end

endmodule
