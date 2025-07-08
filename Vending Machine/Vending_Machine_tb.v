`timescale 1ns / 1ps

module Vending_Machine_tb;

    reg CLK, RESET;
    reg [1:0] coin;
    wire Z;
    wire Change_given;
    wire [7:0] Change_out;

    Vending_Machine uut (
        .CLK(CLK),
        .RESET(RESET),
        .coin(coin),
        .Z(Z),
        .Change_given(Change_given),
        .Change_out(Change_out)
    );

    // Clock Generation
    always #5 CLK = ~CLK;

    initial begin
        // Initialize
        CLK = 0;
        RESET = 1;
        coin = 2'b00;
        #10;
        RESET = 0;

        // -----------------------
        // User 1: 20 + 20 = 40
        // -----------------------
        $display("User 1: Insert ?20 + ?20 (Expect Z=1, Change=0)");
        coin = 2'b01; #10;  // ?20
        coin = 2'b01; #10;  // ?20
        coin = 2'b00; #10;  // idle
        #20;

        // -----------------------
        // Reset
        // -----------------------
        RESET = 1; #10; RESET = 0;

        // -----------------------
        // User 2: 50 = 50
        // -----------------------
        $display("User 2: Insert ?50 (Expect Z=1, Change=10)");
        coin = 2'b10; #10;  // ?50
        coin = 2'b00; #10;  // idle
        #20;

        // -----------------------
        // Reset
        // -----------------------
        RESET = 1; #10; RESET = 0;

        // -----------------------
        // User 3: 10 + 20 + 20 = 50
        // -----------------------
        $display("User 3: Insert ?10 + ?20 + ?20 (Expect Z=1, Change=10)");
        coin = 2'b00; #10;  // ?10
        coin = 2'b01; #10;  // ?20
        coin = 2'b01; #10;  // ?20
        coin = 2'b00; #10;  // idle
        #20;

        $finish;
    end

endmodule
