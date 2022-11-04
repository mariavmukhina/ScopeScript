function [] = doTimeLapseInFcScopeList(fcScopeList)
%DOTIMELAPSEINFCSCOPELIST gets all the timepoints and calculates the smallest time period to
% accomodate every event
% i will append all the timepoints together
% sort it
% find unique diff
% calculate gcd
% use that as period

global masterFileMaker;
numFcScope = numel(fcScopeList);
startDelay = fcScopeList{1}.startDelay;
uberTimePoints = [];
for i = 1:numFcScope
    parsedAndValues = parseParamsForFunctions(fcScopeList{i});
    executeOnly = fcScopeList{i}.executeOnly;
    for j = executeOnly
        currTimePoints = parsedAndValues.values{j}{3};
        if ~ischar(currTimePoints)
            uberTimePoints = [uberTimePoints currTimePoints];
        end
    end
end
%setup period
uberTimePoints = sort(uberTimePoints);
periods = unique(diff(uberTimePoints));
timeLength = unique(max(uberTimePoints(:)));
timeLength(timeLength == Inf) = [];
if isempty(timeLength)
    warning('timepoints are not defined in fcScope objs');
    return;
end
useperiod = gcdInArray(periods(periods>0));
Nsamples = round(timeLength/useperiod)+1;
% setup new timelapse folder
masterFileMaker.setupTimeLapseFolder(fcScopeList{1});

% setup timer
% clear timers
t = timerfind('Name','timeLapse');
delete(t);
% create new timer
t = timer();

set(t,'Name','timeLapse');
set(t,'ExecutionMode','fixedRate');
set(t,'Period',useperiod);
set(t,'TasksToExecute',Nsamples);
set(t,'BusyMode','drop');
set(t,'StartFcn',{@my_callback_fcn, @initForNextInFcScopeList,fcScopeList});
set(t,'ErrorFcn',{@terminateFunc});
set(t,'StopFcn',{@stopFunc});
set(t,'TimerFcn',{@my_callback_fcn, @executeFunctionsInFcScopeList,fcScopeList});
set(t','StartDelay',startDelay);
try
    fprintf('timer starting with delay(secs): %i, period(secs): %i, timeLength(secs): %i, Nsamples: %i\n',startDelay,useperiod,timeLength,Nsamples);
    start(t);
catch
    disp('doTimelapse failed');
end
end

function my_callback_fcn(obj, event, func, funcArg)
fprintf('===');
txt1 = '() executed at ';
event_time = datestr(event.Data.time);
msg = [func2str(func) txt1 event_time];
fprintf('%s==========\n',msg);
func(funcArg);
end

function terminateFunc(obj,event)
    global masterFileMaker;
    disp('error in doTimelapse');
    masterFileMaker.reset();
end

function stopFunc(obj,event)
    global masterFileMaker;
    fcScopeStop = scopeParams();
    endFunction = fcScopeStop.endFunction;
    if ~isempty(endFunction)
        disp('running stop function in timer');
        endFunction();
    end
    disp('TimeLapse Finished');
    masterFileMaker.reset();
end
