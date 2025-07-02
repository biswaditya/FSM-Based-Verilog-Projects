`timescale 1ns / 1ps

module Sequence_detector_tb;

    reg Din;
    reg CLK;
    reg RESET;

    wire Z;
    wire [2:0] state;
    wire [2:0] Next_state;

    // DUT instantiation
    Sequence_detector uut (
        .Din(Din),
        .CLK(CLK),
        .RESET(RESET),
        .Z(Z),
        .state(state),
        .Next_state(Next_state)
    );

    // Clock generation: 10ns period
    always #10 CLK = ~CLK;

    initial begin
        $display("Time\tCLK\tRESET\tDin\tZ\tState\tNext_state");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%b\t%b", 
            $time, CLK, RESET, Din, Z, state, Next_state);

        // Initialize signals
        CLK = 0;
        RESET = 1;
        Din = 0;

        #20 RESET = 0;

        // Input sequence with overlapping 11011 patterns
        #20 Din = 1; // 1
        #20 Din = 1; // 1
        #20 Din = 0; // 0
        #20 Din = 1; // 1
        #20 Din = 1; // 1 ? ? 1st match

        #20 Din = 0; // 0
        #20 Din = 1; // 1
        #20 Din = 1; // 1 ? ? 2nd match

        #20 Din = 0; // 0
        #20 Din = 1; // 1
        #20 Din = 1; // 1 ? ? 3rd match

        #20 Din = 0; // 0
        #20 Din = 1; // 1
        #20 Din = 1; // 1 ? ? 4th match

        // Add some extra to show no detection
        #20 Din = 0;
        #20 Din = 0;
        #20 Din = 1;

        #20 $finish;
    end

endmodule
