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

GRR=10'b0000000001,

LDGRR=10'b0000000010,

YRR=10'b0000000100,

LDYRR=10'b0000001000,

RRR1=10'b0000010000,

RGG=10'b0000100000,

LDRGG=10'b0001000000,

RYY=10'b0010000000,

LDRYY= 10'b0100000000,

RRR2=10'b1000000000,

GREEN=2'b01,
YELLOW=2'b10,
RED=2'b11;

parameter
  YELLOWDURATION =   5,      
  NSGREENDURATION = 45,   
  EWGREENDURATION = 15;  
	

logic [9:0] state, nextstate;

logic load, decr, timeup;
logic [7:0] value;

counter c1 (Clock, Reset, load, value, decr, timeup);

always_ff@(posedge Clock) begin
if(Reset)
	state<=RRR2;
else
	state<=nextstate;
end

always_comb begin
	{load,decr,value}=0;
	case(state)

	GRR:    begin 
		L1=GREEN; L2=RED; L3=RED;
		load=1'b1; decr=1'b0; value=NSGREENDURATION-2;
		nextstate=LDGRR;
		end

	LDGRR:  begin
		L1=GREEN; L2=RED; L3=RED;
		load=1'b0;decr=1'b1;value=0;
		if(timeup) begin
			if((~S1 || S2 || S3)) 
				nextstate=LDGRR;
				
			else
				nextstate=YRR;
			end
		else	
			nextstate=LDGRR;
		end

        YRR:   begin L1=YELLOW; L2=RED; L3=RED; 
		     load=1'b1; decr=1'b0; value=YELLOWDURATION-2;
		     nextstate=LDYRR;
	       end
   	

	LDYRR:  begin 
		L1=YELLOW; L2=RED; L3=RED;
		load=1'b0;decr=1'b1;value=0; 
		if(timeup) 
		     nextstate=RRR1;
		else 
		     nextstate=LDYRR;
		end

	RRR1:  begin L1=RED; L2=RED; L3=RED;
		     nextstate=RGG;
  	       end

        RGG: begin L1=RED; L2=GREEN; L3=GREEN;
		   load=1'b1; decr=1'b0; value=EWGREENDURATION-2;
		  nextstate=LDRGG;
	     end
	
	LDRGG: begin 
		L1=RED; L2=GREEN; L3=GREEN;
		load=1'b0;decr=1'b1;value=0;  
		if(timeup) 
		     nextstate=RYY;
		else 
		     nextstate=LDRGG;
		end

        RYY: begin L1=RED; L2=YELLOW; L3=YELLOW;
		  load=1'b1; decr=1'b0; value=YELLOWDURATION-2;
		   nextstate=LDRYY;		  
	    end
	
	LDRYY: begin 
		L1=RED; L2=YELLOW; L3=YELLOW;
		load=1'b0;decr=1'b1;value=0; 
		if(timeup) 
		     nextstate=RRR2;
		else 
		     nextstate=LDRYY;
		
		end

        RRR2:  begin L1=RED; L2=RED; L3=RED;
		     nextstate=GRR;
  	       end

	endcase


end
  
endmodule: fsm