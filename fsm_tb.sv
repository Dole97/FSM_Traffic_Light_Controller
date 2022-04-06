module fsmassertions(Clock, Reset, S1, S2, S3, L1, L2, L3);

input Clock;
input Reset;
input S1, S2, S3;
input [1:0] L1, L2, L3;

localparam GREEN=2'b01,
YELLOW=2'b10,
RED=2'b11;

parameter 
  All_Lights_RED = 1,
  YELLOWDURATION = 5,      
  NSGREENDURATION = 45,   
  EWGREENDURATION = 15;

logic sensors[2:0];

assign sensors = {S1, S2, S3};

property sensor_unknown_values_p;
@(posedge Clock) disable iff (Reset) (!$isunknown(sensors));
endproperty

property L2_L3_EQUAL_p;
@(posedge Clock) disable iff (Reset) (L2 == L3);
endproperty

property L1_NOT_Y2G_p;
@(posedge Clock) disable iff (Reset) ((L1==YELLOW) |=> (L1!=GREEN));
endproperty

property L1_NOT_R2Y_p;
@(posedge Clock) disable iff (Reset) ((L1==RED) |=> (L1!=YELLOW));
endproperty

property L1_NOT_G2R_p;
@(posedge Clock) disable iff (Reset) ((L1==GREEN) |=> (L1!=RED));
endproperty

property L2_NOT_Y2G_p;
@(posedge Clock) disable iff (Reset) ((L2==YELLOW) |=> (L2!=GREEN));
endproperty

property L2_NOT_R2Y_p;
@(posedge Clock) disable iff (Reset) ((L2==RED) |=> (L2!=YELLOW));
endproperty

property L2_NOT_G2R_p;
@(posedge Clock) disable iff (Reset) ((L2==GREEN) |=> (L2!=RED));
endproperty

property L3_NOT_Y2G_p;
@(posedge Clock) disable iff (Reset) ((L3==YELLOW) |=> (L3!=GREEN));
endproperty

property L3_NOT_R2Y_p;
@(posedge Clock) disable iff (Reset) ((L3==RED) |=> (L3!=YELLOW));
endproperty

property L3_NOT_G2R_p;
@(posedge Clock) disable iff (Reset) ((L3==GREEN) |=> (L3!=RED));
endproperty

property L1YELLOW_L23RED_p;
@(posedge Clock) disable iff (Reset) ((L1==YELLOW) |-> ((L2==RED) & (L3==RED)));
endproperty

property L2YELLOW_p;
@(posedge Clock) disable iff (Reset) ((L2==YELLOW) |-> (L1==RED));
endproperty

property L3YELLOW_p;
@(posedge Clock) disable iff (Reset) ((L3==YELLOW) |-> (L1==RED));
endproperty

property L1GREEN_L23RED_p;
@(posedge Clock) disable iff (Reset) ((L1==GREEN) |-> ((L2==RED) & (L3==RED)));
endproperty

property L2GREEN_p;
@(posedge Clock) disable iff (Reset) ((L2==GREEN) |-> (L1==RED));
endproperty

property L3GREEN_p;
@(posedge Clock) disable iff (Reset) ((L3==GREEN) |-> (L1==RED));
endproperty

property L2_GREEN_TIME_p;
@(posedge Clock) disable iff (Reset) (((L2!=GREEN) ##1 (L2==GREEN) |-> (L2==GREEN) [*EWGREENDURATION] ##1 (L2!=GREEN)));
endproperty

property L3_GREEN_TIME_p;
@(posedge Clock) disable iff (Reset) (((L3!=GREEN) ##1 (L3==GREEN) |-> (L3==GREEN) [*EWGREENDURATION] ##1 (L3!=GREEN)));
endproperty

property L2_YELLOW_TIME_p;
@(posedge Clock) disable iff (Reset) (((L2!=YELLOW) ##1 (L2==YELLOW) |-> (L2==YELLOW) [*YELLOWDURATION] ##1 (L2!=YELLOW)));
endproperty

property L3_YELLOW_TIME_p;
@(posedge Clock) disable iff (Reset) (((L3!=YELLOW) ##1 (L3==YELLOW) |-> (L3==YELLOW) [*YELLOWDURATION] ##1 (L3!=YELLOW)));
endproperty

property L2_RED_TIME_p;
@(posedge Clock) disable iff (Reset)(((L2!=RED) ##1 (L2==RED) |=> (L2==RED) [*(NSGREENDURATION+YELLOWDURATION+All_Lights_RED):$] ##1 (L2!=RED)));
endproperty

property L3_RED_TIME_p;
@(posedge Clock) disable iff (Reset) (((L3!=RED) ##1 (L3==RED) |=> (L3==RED) [*(NSGREENDURATION+YELLOWDURATION+All_Lights_RED):$] ##1 (L3!=RED)));
endproperty

property L1_GREEN_TIME_p;
@(posedge Clock) disable iff (Reset) (((L1!=GREEN)##1(L1==GREEN)) [*NSGREENDURATION-1] ##1 ((($past(S1) && ~$past(S2) && ~$past(S3)) && (L1 == GREEN))[*0:$]) ##1 (L1!=GREEN)));
endproperty

property L1_YELLOW_TIME_p;
@(posedge Clock) disable iff (Reset) (((L1!=YELLOW) ##1 (L1==YELLOW) |-> (L1==YELLOW) [*YELLOWDURATION] ##1 (L1!=YELLOW)));
endproperty

property L1_RED_TIME_p;
@(posedge Clock) disable iff (Reset) (((L1!=RED) ##1 (L1==RED) |=> (L1==RED) [*(EWGREENDURATION+YELLOWDURATION+All_Lights_RED)] ##1 (L1!=RED)));
endproperty



 sensor_unknown_values_a: assert property (sensor_unknown_values_p) else $error("Sensors have unknown values");
 
 L2_L3_EQUAL_a: assert property (L2_L3_EQUAL_p) else $error("L2 not equal to L3");

 L1_NOT_Y2G_a: assert property (L1_NOT_Y2G_p) else $error("L1 turned GREEN immediately after YELLOW");
 L1_NOT_R2Y_a: assert property (L1_NOT_R2Y_p) else $error("L1 turned YELLOW immediately after RED");
 L1_NOT_G2R_a: assert property (L1_NOT_G2R_p) else $error("L1 turned RED immediately after GREEN");

 L2_NOT_Y2G_a: assert property (L2_NOT_Y2G_p) else $error("L2 turned GREEN immediately after YELLOW");
 L2_NOT_R2Y_a: assert property (L2_NOT_R2Y_p) else $error("L2 turned YELLOW immediately after RED");
 L2_NOT_G2R_a: assert property (L2_NOT_G2R_p) else $error("L2 turned RED immediately after GREEN");

 L3_NOT_Y2G_a: assert property (L3_NOT_Y2G_p) else $error("L3 turned GREEN immediately after YELLOW");
 L3_NOT_R2Y_a: assert property (L3_NOT_R2Y_p) else $error("L3 turned YELLOW immediately after RED");
 L3_NOT_G2R_a: assert property (L3_NOT_G2R_p) else $error("L3 turned RED immediately after GREEN");

 L1YELLOW_L23RED_a: assert property (L1YELLOW_L23RED_p) else $error ("Cross traffic lights improper outputs: at L1=YELLOW");
 L2YELLOW_a: assert property (L2YELLOW_p) else $error ("Cross traffic lights improper outputs: at L2=YELLOW");
 L3YELLOW_a: assert property (L3YELLOW_p) else $error ("Cross traffic lights improper outputs: at L3=YELLOW");

 L1GREEN_L23RED_a: assert property (L1GREEN_L23RED_p) else $error ("Cross traffic lights improper outputs: at L1=GREEN");
 L2GREEN_a: assert property (L2GREEN_p) else $error ("Cross traffic lights improper outputs: L2=GREEN");
 L3GREEN_a: assert property (L3GREEN_p) else $error ("Cross traffic lights improper outputs: L3=GREEN");

 L2_GREEN_TIME_a: assert property (L2_GREEN_TIME_p) else $error("L2 GREEN light time violation");
 L3_GREEN_TIME_a: assert property (L3_GREEN_TIME_p) else $error("L3 GREEN light time violation");

 L2_YELLOW_TIME_a: assert property (L2_YELLOW_TIME_p) else $error("L2 YELLOW light time violation");
 L3_YELLOW_TIME_a: assert property (L3_YELLOW_TIME_p)else $error("L3 YELLOW light time violation");

 L2_RED_TIME_a: assert property (L2_RED_TIME_p) else $error("L2 RED light time violation");
 L3_RED_TIME_a: assert property (L3_RED_TIME_p) else $error("L3 RED light time violation");

 L1_GREEN_TIME_a: assert property (L1_GREEN_TIME_p) else $error("L1 GREEN light time violation");

 L1_YELLOW_TIME_a: assert property (L1_YELLOW_TIME_p) else $error("L1 YELLOW light time violation");

 L1_RED_TIME_a: assert property (L1_RED_TIME_p) else $error("L1 RED light time violation");


endmodule:fsmassertions

module top;

  wire [1:0]  L1, L2, L3;
  logic  S1, S2, S3, Clock, Reset;

fsm f1 (Clock, Reset, S1, S2, S3, L1, L2, L3);
bind fsm:f1 fsmassertions fa(Clock, Reset, S1, S2, S3, L1, L2, L3);

parameter TESTCASES =5000;
 
initial
  begin
   Clock = 1;
   forever #(5) Clock = ~Clock;
  end

initial
 begin
 Reset = 1;
 repeat (2) @(negedge Clock);
 Reset = 0;

 for(int i=0;i<TESTCASES;i++) 
   begin
     {S1,S2,S3}=$urandom_range(0,7);
     @(negedge Clock);
   end

   $finish();
 end

endmodule:top



  
  
  


