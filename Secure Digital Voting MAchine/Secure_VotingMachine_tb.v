`timescale 1ns / 1ps

module Secure_VotingMachine_tb;

    reg [1:0] VOTE_IN;
    reg RESET;
    reg CLK = 0;
    reg ENABLE;
    reg ADMIN_RESET;

    wire [3:0] count_A, count_B, count_C;
    wire [2:0] state, next_state;

    // Instantiate the DUT
    Secure_VotingMachine uut (
        .VOTE_IN(VOTE_IN),
        .RESET(RESET),
        .CLK(CLK),
        .ENABLE(ENABLE),
        .ADMIN_RESET(ADMIN_RESET),
        .count_A(count_A),
        .count_B(count_B),
        .count_C(count_C),
        .state(state),
        .next_state(next_state)
    );

    // Clock generation (10ns period)
    always #5 CLK = ~CLK;

    initial begin
        $display("Time\tState\tNext\tVOTE_IN\tEnable\tA\tB\tC");
        $monitor("%0t\t%b\t%b\t%2b\t%b\t%d\t%d\t%d", 
            $time, state, next_state, VOTE_IN, ENABLE, count_A, count_B, count_C);

        // Initialize
        RESET = 1; ENABLE = 0; VOTE_IN = 2'b00; ADMIN_RESET = 0;
        #20 RESET = 0;

        // Try voting without ENABLE — should not count
        #10 VOTE_IN = 2'b01;
        #10 VOTE_IN = 2'b00;

        // Enable voting for Candidate A
        #10 ENABLE = 1;
        #10 VOTE_IN = 2'b01; // Vote A
        #10 VOTE_IN = 2'b00;
        #10 ENABLE = 0;

        // Enable voting for Candidate B
        #10 ENABLE = 1;
        #10 VOTE_IN = 2'b10; // Vote B
        #10 VOTE_IN = 2'b00;
        #10 ENABLE = 0;

        // Enable voting for Candidate C
        #10 ENABLE = 1;
        #10 VOTE_IN = 2'b11; // Vote C
        #10 VOTE_IN = 2'b00;
        #10 ENABLE = 0;

        // Vote A again
        #10 ENABLE = 1;
        #10 VOTE_IN = 2'b01;
        #10 VOTE_IN = 2'b00;
        #10 ENABLE = 0;

        // ADMIN RESET (secure clear)
        #20 ADMIN_RESET = 1;
        #10 ADMIN_RESET = 0;

        // Voting after reset
        #10 ENABLE = 1;
        #10 VOTE_IN = 2'b10; // Vote B
        #10 VOTE_IN = 2'b00;
        #10 ENABLE = 0;

        #20 $finish;
    end

endmodule
