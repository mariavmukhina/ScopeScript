function [] = executeFunctions(varargin)
%EXECUTEFUNCTIONS
% executeFunctions() will instantiate an scopeParams then execute only
% the functions within it
% executeFunctions(fcScope) will execute the functions inside fcScope
% object
% executeFunctions({fcScope1,fcScope2}) will execute the functions inside
% the list of fcScopes
global stageCoordinates;
if scopeParams.sensorDefectCorrection
    sensorDefectCorrectON();
else
    sensorDefectCorrectOFF();
end
if isempty(varargin)
    % check if stageCoordinates is specified
    if isempty(stageCoordinates)
        fcScope = scopeParams();
        executeFunctionsInFcScopeList({fcScope});
    else
        disp('taking fcScope Z stacks at XY locations from stageCoordinates list');
        executeFunctionsInFcScopeList(stageCoordinates);
    end
else
    if isnumeric(varargin{1})
        fcScope = scopeParams();
        fcScope.executeOnly = varargin{1};
        executeFunctionsInFcScopeList({fcScope});
    else
        fcScopeList = varargin{1};
        if iscell(fcScopeList)
            executeFunctionsInFcScopeList(fcScopeList);
        else
            executeFunctionsInFcScopeList({fcScopeList});
        end
    end
    
end

unlockBrightFieldLED();
end

