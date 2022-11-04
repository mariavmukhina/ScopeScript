function timerStatus = isATimerOn()
%ISATIMERON Summary of this function goes here
%   Detailed explanation goes here

timer = timerfind('Name','timeLapse');

if isempty(timer)
   timerStatus = false; 
else
   timerStatus = true; 
end

end

