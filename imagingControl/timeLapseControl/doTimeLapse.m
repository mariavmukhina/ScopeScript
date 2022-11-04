function [] = doTimeLapse(varargin)
%DOTIMELAPSE
% doTimeLapse() will instantiate an scopeParams and execute timelapse
% doTimeLapse(fcScope) will execute timelapse defined in fcScope
% doTimeLapse(fcScopeList) will execute timelapse over that of the list

global stageCoordinates;
if isempty(varargin)
    % check if stageCoordinates is specified
    if isempty(stageCoordinates)
        fcScope = scopeParams();
        doTimeLapseInFcScopeList({fcScope});
    else
        disp('taking fcScope Z stacks at stageCoordinates XY locations');
        doTimeLapseInFcScopeList(stageCoordinates);
    end
else
    fcScopeList = varargin{1};
    if iscell(fcScopeList)
        doTimeLapseInFcScopeList(fcScopeList);
    else
        doTimeLapseInFcScopeList({fcScopeList});
    end
end

end

