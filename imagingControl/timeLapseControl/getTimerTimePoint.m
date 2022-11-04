function timePointNum = getTimerTimePoint()
%GETTIMERTIMEPOINT finds active timer and returns how many timepoints have
%passed

timer = timerfind('Name','timeLapse');
if ~isempty(timer)
   timePointNum = get(timer,'TasksExecuted'); 
else
   timePointNum = []; 
end


end

