function elapsedSeconds = returnSecsFromRunningTimer()
%RETURNSECSFROMRUNNINGTIMER give a running timer, this function will return
%the amount of time elapsed in seconds

timer = timerfind('Name','timeLapse');
if ~isempty(timer)
   currTimePoint = get(timer,'TasksExecuted'); 
   period        = get(timer,'Period');
   elapsedSeconds = period*(currTimePoint-1);
else
   elapsedSeconds = []; 
end


end

