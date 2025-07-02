`timescale 1ns / 1ps

//Aim to detect Sequence 11011 by Moore's Machine
module Sequence_detector(
    input Din, 
    input CLK,
    input RESET,
    output reg Z,
    output reg [2:0] state,Next_state
    );
    
     parameter Sin=3'b000,S1=3'b001,S11=3'b010,S110=3'b011, S1101=3'b100, S11011=3'b111;
     
     always@(posedge CLK or posedge RESET)
     begin  if(RESET) state <= Sin;
            else  state <= Next_state;
     end
     
     always@(*)
     begin   case(state)
             Sin : begin if(Din==1) Next_state<=S1;
                   else Next_state<=Sin; end
             S1 : begin if(Din==1) Next_state<=S11;
                   else Next_state<=Sin;  end
             S11 : begin if(Din==1) Next_state<=S11;
                   else Next_state<=S110;  end
             S110 : begin if(Din==1) Next_state<=S1101;
                    else Next_state<=Sin;  end
             S1101 : begin if(Din==1) Next_state<=S11011;
                     else Next_state<=Sin;  end 
             S11011 : begin if(Din==1) Next_state<=S11;
                    else Next_state<=S110; end
           default : Next_state<=Sin;    
           endcase      
     end
     
         always @(*) begin
         case (state)
             S11011: Z = 1;//Pattern Detected
             default: Z = 0;
         endcase
     end
endmodule
