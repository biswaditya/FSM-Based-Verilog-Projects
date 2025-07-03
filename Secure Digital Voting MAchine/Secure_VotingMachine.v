`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2025 21:22:53
// Design Name: 
// Module Name: Secure_VotingMachine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Secure_VotingMachine(
    input [1:0] VOTE_IN,// 00 - no vote, 01 - candidate A, 10 - candidate B, 11 - candidate C
    input RESET,
    input CLK,
    input ENABLE,// Enables voting (access control)
    input ADMIN_RESET,// Admin reset (More secure )
    output reg [3:0] count_A,
    output reg [3:0] count_B,
    output reg [3:0] count_C,
    output reg [2:0] state,next_state
    );
        parameter IDLE = 3'b000,
              WAIT_FOR_VOTE = 3'b001,
              VOTE_A = 3'b010,
              VOTE_B = 3'b011,
              VOTE_C = 3'b100;
              initial
              begin
              count_A=0;
              count_B=0;
              count_C=0;
              end
              
       always@(posedge CLK or posedge RESET or posedge ADMIN_RESET) 
          begin     if (RESET || ADMIN_RESET) state <= IDLE;
                    else state <= next_state;
          end 
          
      always@(*)   
      begin 
              case(state)
              IDLE : begin if (ENABLE) next_state = WAIT_FOR_VOTE; else next_state= IDLE; end
              WAIT_FOR_VOTE:
                  begin
                  case (VOTE_IN)
                      2'b01: next_state = VOTE_A;
                      2'b10: next_state = VOTE_B;
                      2'b11: next_state = VOTE_C;
                      default: next_state = WAIT_FOR_VOTE;
                  endcase
                   end
             VOTE_A, VOTE_B, VOTE_C: next_state = IDLE;
             default : next_state= IDLE;
          endcase
      end
      
      always @(posedge CLK or posedge ADMIN_RESET) begin
          if (ADMIN_RESET) begin
              count_A <= 0;
              count_B <= 0;
              count_C <= 0;
          end else begin
              case (state)
                  VOTE_A: count_A <= count_A + 1;
                  VOTE_B: count_B <= count_B + 1;
                  VOTE_C: count_C <= count_C + 1;
              endcase
          end
      end
      
      
            
endmodule
