function [] = stageAppend(varargin)
%STAGEAPPEND allows to save multiple XY locations of the microscope stage alonside corresponding PFS offsets to the stageCoordinates list
%the stageCoordinates list is then used to execute fcScopes (Z stacks) at the selected locations as a timeLapse
%default time interval between fcScopes at different locations is 5 sec
%it can also be provided as an argument of stageAppend()

if ~isempty(varargin)
    timeOffset = varargin{1};
else
    timeOffset = 5;%sec
end

global stageCoordinates;
fcScopeCurrent = scopeParams('saveStage');

parsed = regexp(properties(fcScopeCurrent),'timePoints[0-9]+','match');
parsed = removeEmptyCells(parsed);
numel(stageCoordinates)
if ~isempty(parsed)
    for i = 1:numel(parsed)
       currTimePoints = getfield(fcScopeCurrent,parsed{i}{1});
       offsetTimePoints = currTimePoints+numel(stageCoordinates)*timeOffset;
       setfield(fcScopeCurrent,parsed{i}{1},offsetTimePoints);
    end
end


stageCoordinates{end+1} = fcScopeCurrent;


end

