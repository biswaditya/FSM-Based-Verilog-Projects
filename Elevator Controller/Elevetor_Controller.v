`timescale 1ns / 1ps

module Elevetor_Controller(
    input CLK,
    input RESET,
    input Control_TYPE, // 1=DTF, 0=UPDN
    input UPDN, //Up_Down_Control UP=1,DOWN=0
    input [2:0]DTF, //Direct_to_flor Control s_gnd=3'b000,s_f1=3'b001,s_f2=3'b010,s_f3=3'b011,s_f4=3'b100
    output reg [23:0]OUT,//GND,F1,F2,F3,F4(Total bits = Number of characters × 8)
    output reg [2:0] state,next_state
    );
    parameter s_gnd=3'b000,s_f1=3'b001,s_f2=3'b010,s_f3=3'b011,s_f4=3'b100;
    
    always@(posedge CLK or posedge RESET)
    begin if(RESET) state<=s_gnd;
          else state<=next_state;
    end
    
    always@(*)
    begin 
         if(Control_TYPE==1)//user want to control by direct to floor controller
         begin
         if(DTF!=state)
         begin
                 if(DTF < state)
                 next_state = state - 1; // Move up
                 else if(DTF > state) next_state = state + 1;// Move down
         end        
         else next_state = state; //user in the right state
         end 
    
        else //user want to control by up down controller
        begin 
         case(state)
          s_gnd : if(UPDN==1)next_state<=state+1;
                  else next_state<=state;
          s_f1 : if(UPDN==1)next_state<=state+1;
                   else next_state<=state-1;
          s_f2 : if(UPDN==1)next_state<=state+1;
                  else next_state<=state-1;
          s_f3 : if(UPDN==1)next_state<=state+1;
                  else next_state<=state-1;  
          s_f4 : if(UPDN==1)next_state<=state;
                else next_state<=state-1 ;   
        default: next_state<=state; 
        endcase                   
        end 
   end
    
    always @(*) begin
       case (state)
           s_gnd: OUT = "GND";
           s_f1 : OUT = "F1 ";
           s_f2 : OUT = "F2 ";
           s_f3 : OUT = "F3 ";
           s_f4 : OUT = "F4 ";
           default: OUT = "ERR ";
       endcase
   end
   
endmodule
