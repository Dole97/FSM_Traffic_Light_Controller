
module fsm(Clock, Reset, S1, S2, S3, L1, L2, L3); 
input Clock; 
input Reset; 
input       // sensors for approaching vehicles 
  S1,      // Northbound on SW 4th Avenue 
  S2,      // Eastbound on SW Harrison Street 
  S3;      // Westbound on SW Harrison Street 
   
output reg [1:0]   // outputs for controlling traffic lights  
  L1,      // light for NB SW 4th Avenue 
  L2,      // light for EB SW Harrison Street 
  L3;      // light for WB SW Harrison Street 


parameter

Y1=10'b0000000001,

Y2=10'b0000000010,

Y3=10'b0000000100,

Y4=10'b0000001000,

Y5=10'b0000010000,

Y6=10'b0000100000,

Y7=10'b0001000000,

Y8=10'b0010000000,

Y9= 10'b0100000000,

Y10=10'b1000000000,

GREEN=2'b01,
YELLOW=2'b10,
RED=2'b11;

logic [9:0] state, nextstate;

logic load, decr, timeup;
logic [7:0] value;

counter c1 (Clock, Reset, load, value, decr, timeup);

always_ff@(posedge Clock) begin
if(Reset)
	state<=Y10;
else
	state<=nextstate;
end

always_comb begin

	case(state)

	Y1:    begin 
		L1=GREEN; L2=RED; L3=RED;
		load=1'b1; decr=1'b0; value=43;
		nextstate=Y2;
		end

	Y2:  begin
		load=1'b0;decr=1'b1;value=0;
		if(timeup) begin
			if({S1,S2,S3}==3'b100) 
				nextstate=Y2;
				
			else
				nextstate=Y3;
			end
		else	
			nextstate=Y2;
		end

    Y3: begin L1=YELLOW; L2=RED; L3=RED; 
		    load=1'b1; decr=1'b0; value=3;
		    nextstate=Y4;
	     end
   	

	Y4:  begin 
		load=1'b0;decr=1'b1;value=0; 
		if(timeup) 
		     nextstate=Y5;
		else 
		     nextstate=Y4;
		end

	Y5:  begin L1=RED; L2=RED; L3=RED;
		     nextstate=Y6;
  	       end

    Y6: begin L1=RED; L2=GREEN; L3=GREEN;
		  load=1'b1; decr=1'b0; value=13;
		  nextstate=Y7;
	    end
	
	Y7: begin 
		load=1'b0;decr=1'b1;value=0;  
		if(timeup) 
		     nextstate=Y8;
		else 
		     nextstate=Y7;
		end

    Y8: begin L1=RED; L2=YELLOW; L3=YELLOW;
		 load=1'b1; decr=1'b0; value=3;
		 nextstate=Y9;		  
	    end
	
	Y9: begin 
		load=1'b0;decr=1'b1;value=0; 
		if(timeup) 
		     nextstate=Y10;
		else 
		     nextstate=Y9;
		
		end

    Y10:  begin L1=RED; L2=RED; L3=RED;
		   nextstate=Y1;
  	      end

	endcase

end
endmodule