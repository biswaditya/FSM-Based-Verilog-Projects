`timescale 1ns / 1ps

//4_way Traffic Light Controller
//NS = NORTH SOUTH WAY ,EW = EAST WEST WAY
module Traffic_4Way_Controller(
    input CLK,RESET,
    output reg NS_RED, NS_YELLOW, NS_GREEN,
    output reg EW_RED, EW_YELLOW, EW_GREEN,
    output reg [4:0] timer
    );
    reg [1:0] current_state;
   
    // 1.NS Green, EW Red 2.NS Yellow, EW Red 3.NS Red, EW Green 4.NS Red, EW Yellow
    parameter S0_NS_GREEN_EW_RED    = 2'b00;
    parameter S1_NS_YELLOW_EW_RED   = 2'b01;
    parameter S2_NS_RED_EW_GREEN    = 2'b10;
    parameter S3_NS_RED_EW_YELLOW   = 2'b11;
    // Timing Parameters
    parameter GREEN_TIME  = 5'd30;
    parameter YELLOW_TIME = 5'd10; 
    //RED time will be automatically GREEN + YELLOW
    
   always @(posedge CLK or posedge RESET) begin
         if (RESET) begin
             current_state <= S0_NS_GREEN_EW_RED;
             timer <= 0;
         end else begin  
             // Check if timer has reached its limit for the current state
             case (current_state)
                 S0_NS_GREEN_EW_RED: begin
                     if (timer == GREEN_TIME) begin
                         current_state <= S1_NS_YELLOW_EW_RED;
                         timer <= 0;
                     end else
                         timer <= timer + 1;
                 end
 
                 S1_NS_YELLOW_EW_RED: begin
                     if (timer == YELLOW_TIME) begin
                         current_state <= S2_NS_RED_EW_GREEN;
                         timer <= 0;
                     end else
                         timer <= timer + 1;
                 end
 
                 S2_NS_RED_EW_GREEN: begin
                     if (timer == GREEN_TIME) begin
                         current_state <= S3_NS_RED_EW_YELLOW;
                         timer <= 0;
                     end else
                         timer <= timer + 1;
                 end
 
                 S3_NS_RED_EW_YELLOW: begin
                     if (timer == YELLOW_TIME) begin
                         current_state <= S0_NS_GREEN_EW_RED;
                         timer <= 0;
                     end else
                         timer <= timer + 1;
                 end
             endcase
         end
     end
 always @(*) begin
        NS_RED = 0; NS_YELLOW = 0; NS_GREEN = 0;
        EW_RED = 0; EW_YELLOW = 0; EW_GREEN = 0;

        case (current_state)
            S0_NS_GREEN_EW_RED: begin
                NS_GREEN = 1; EW_RED = 1;
            end
            S1_NS_YELLOW_EW_RED: begin
                NS_YELLOW = 1; EW_RED = 1;
            end
            S2_NS_RED_EW_GREEN: begin
                NS_RED = 1; EW_GREEN = 1;
            end
            S3_NS_RED_EW_YELLOW: begin
                NS_RED = 1; EW_YELLOW = 1;
            end
        endcase
    end


endmodule
