function [] = initForNextInFcScopeList(fcScopeList)
%INITFORNEXTINFCSCOPELIST will move the stage and setup channel for the
%next timepoint to come
% fcScopeList consists of just one fcScope, then the stagePos does not move
% to the saved one inside the parameter list

currentElapsedTimeInSeconds = returnSecsFromRunningTimer();
if isempty(currentElapsedTimeInSeconds)
    currentElapsedTimeInSeconds = 0;
end
numFcScope = numel(fcScopeList);
nextTimePoint = inf;
for i = 1:numFcScope
    parsedAndValues = parseParamsForFunctions(fcScopeList{i});
    % several timepoints exist per function i parsedAndValues
    % find the timepoint that is minimally > currentElapsed
    executeOnly = fcScopeList{i}.executeOnly;
    for j = executeOnly
        currTimePointVector = parsedAndValues.values{j}{3};
        if ~strcmp(currTimePointVector,'none')
            currMinTimePoint = min(currTimePointVector(currTimePointVector > currentElapsedTimeInSeconds));
            nextTimePoint = min(currMinTimePoint,nextTimePoint);
        end
    end
end

if nextTimePoint == inf
   return; 
end
% find the first nextTimePoint and set up its channel and stage pos
for i = 1:numFcScope
    parsedAndValues = parseParamsForFunctions(fcScopeList{i});
    executeOnly = fcScopeList{i}.executeOnly;
    for j = executeOnly
        currTimePointVector = parsedAndValues.values{j}{3};
        if sum(ismember(currTimePointVector,nextTimePoint)) > 0
            % go to stage pos
            if numel(fcScopeList) > 1
                if ~isempty(parsedAndValues.stagePos)
                    fprintf('\n\n');
                    fprintf('>>>>> moving to next stagepos:%i\n',i);
                    gotoStagePos(parsedAndValues.stagePos);
                end
            end
            % go to perfect focus
            waitForSystem();
            % setup channel
            fprintf('>>>>> setting next channel: %s\n',parsedAndValues.values{j}{2}{1}{1});
            fprintf('\n\n');
            updateChannelGivenCommand(parsedAndValues.values{j}{2});
            currentPFSState = getPFSState();
            if currentPFSState
                waitForPFS(parsedAndValues.pfsOffset);
            end
            return;
        end
    end
end
end

