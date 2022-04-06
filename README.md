# FSM_Traffic_Light_Controller
Designed a finite state machine to control the traffic lights at the 
intersection of SW 4th Avenue and SW Harrison Street in Portland. 


![image](https://user-images.githubusercontent.com/56908161/161885112-e19597cf-a5d8-424b-9cbd-0377975de0be.png)


There are 3 traffic lights L1, L2, L3. There are 3 sensors S1, S2, S3 at each traffic light for detecting the approaching traffic. 

SW 4th Avenue is a three lane one-way street northbound.
West of the intersection SW Harrison Street is a two lane two-way street.
East of the intersection it is a four lane-two way street.
The westbound two lanes split at the intersection with the right lane becoming a right-turn only lane.

Following are the operating conditions of the traffic lights:

1) Signals remain yellow for five seconds before becoming red.
 For safety, all lights are red for one second. 

2) Traffic traveling on SW 4th Avenue always have at least 45 seconds of green while traffic travelling east or westbound
 on SW Harrison Street always have 15 seconds of green.

3) If there is no approaching traffic on SW Harrison then the light on SW 4th Avenue will remain green longer than 45 seconds 
if cars are still approaching on SW 4th Avenue.






# Count-Down Timer
There is also a Count-Down Timer operating at clock rate of 1 Hz to keep track of the time.

![image](https://user-images.githubusercontent.com/56908161/161889362-97b7fe32-652f-4880-92ad-da82e5662a64.png)

The count-down timer can be loaded with an 8-bit value (value) using a control signal (load).

The counter has another control signal (decr) that causes to counter to count down. 

If neither signal is asserted the timer retains the current value. When it reaches zero, the output timeup becomes 1. 

The count remains zero until reloaded. The timer has a synchronous reset.




