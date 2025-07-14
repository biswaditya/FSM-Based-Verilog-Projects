`timescale 1ns / 1ps

module Elevator_Controller_tb;
    // Inputs
reg CLK;
reg RESET;
reg Control_TYPE;
reg UPDN;
reg [2:0] DTF;

// Outputs
wire [23:0] OUT;
wire [2:0] state, next_state;

Elevetor_Controller uut (
    .CLK(CLK),
    .RESET(RESET),
    .Control_TYPE(Control_TYPE),
    .UPDN(UPDN),
    .DTF(DTF),
    .OUT(OUT),
    .state(state),
    .next_state(next_state)
);

 // Clock Generation
    always #5 CLK = ~CLK;
    initial
    begin
    // Initialize inputs
    CLK = 0;
    RESET = 1;
    Control_TYPE = 0;
    #10;
    RESET = 0;
    UPDN = 1; // go up
    #10;  // GND -> F1
    #10;  // F1 -> F2
    #10;  // F2 -> F3
    #10;  // F3 -> F4
    UPDN = 0;
    #10;  // F4 -> F3
    #10;  // F3 -> F2
    #10;  // F2 -> F1
    #10;  // F1 -> gnd  
    #10;
    RESET = 1;
    Control_TYPE = 1;
    #10; 
    RESET = 0;
    
    DTF = 3'b010; // request F2
    #30;          // GND ? F1 ? F2

    DTF = 3'b100; // request F4
    #30;          // F2 ? F3 ? F4

    DTF = 3'b001; // request F1
    #30;          // F4 ? F3 ? F2 ? F1

    DTF = 3'b011; // request F3
    #20;          // F1 ? F2 ? F3

    DTF = 3'b000; // request GND
    #30;          // F3 ? F2 ? F1 ? GND
    $stop;
    end
        always @(posedge CLK) begin
        $display("Time: %0t | State: %0d | OUT: %s | Next: %0d", 
            $time, state, OUT, next_state);
    end
    
endmodule
