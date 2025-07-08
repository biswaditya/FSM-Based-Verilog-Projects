`timescale 1ns / 1ps
//Sprite Vending Machine(Single Product)
module Vending_Machine(
    input CLK,RESET,
    input [1:0] coin, // Coin's Accepted Are  10, 20 & 50
    output reg Z, //Sprite bottle is OUT
    output reg Change_given, // Flag if change returned
    output reg [7:0] Change_out // Amount of change in decimal (e.g., 10, 20)
    );
    // Sprite is set @RS 40 a bottle
    parameter  Sin=4'b0000,S10 = 4'b0001, S20 = 4'b0010, S30 = 4'b0011, 
    S40 = 4'b0100, S50 = 4'b0101, S60 = 4'b0110, S70 = 4'b0111, S80 = 4'b1000; 
     
    parameter ten = 2'b00, twenty = 2'b01, fifty = 2'b10;
    
    reg [3:0] state, next_state;
    
    always@(posedge CLK or posedge RESET)
    begin if(RESET) state <= Sin;
          else state <= next_state;
    end
    
    always@(state,coin)
    begin  
           case(state)
            Sin: begin if(coin==ten) next_state = S10;
                 else if (coin==twenty) next_state = S20;
                 else next_state = S50;  end
                 
               S10: begin if(coin==ten) next_state = S20;
                      else if (coin==twenty) next_state = S30;
                      else next_state = S60;  end
                      
        S20: begin if(coin==ten) next_state = S30;
             else if (coin==twenty) next_state = S40;
             else next_state = S70;  end      
         
          S30: begin if(coin==ten) next_state = S40;
              else if (coin==twenty) next_state = S50;
              else next_state = S80; end  
              
          S40: next_state = Sin; 
          S50:  next_state = Sin; 
          S60:  next_state = Sin; 
          S70:  next_state = Sin;
          S80:  next_state = Sin;
          default:  next_state = Sin;
          endcase                
     end
     
     always @(state,coin)
     begin
      case(state) 
      Sin: begin Z = 0; Change_given = 0; Change_out = 8'd0; end 
      S10: begin Z = 0; Change_given = 0; Change_out = 8'd0; end 
      S20: begin Z = 0; Change_given = 0; Change_out = 8'd0; end
      S30: begin Z = 0; Change_given = 0; Change_out = 8'd0; end
      S40: begin Z = 1; Change_given = 0; Change_out = 8'd0; end
      S50: begin Z = 1; Change_given = 1; Change_out = 8'd10; end
      S60: begin Z = 1; Change_given = 1; Change_out = 8'd20; end
      S70: begin Z = 1; Change_given = 1; Change_out = 8'd30; end
      S80: begin Z = 1; Change_given = 1; Change_out = 8'd40; end
      default : begin Z = 0; Change_given = 0; Change_out = 8'd0;end 
      endcase
     end
endmodule
