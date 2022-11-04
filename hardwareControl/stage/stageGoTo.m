function [] = stageGoTo(stagePos)
%STAGEGOTO moves the microscope stage to XY position from the stageCoordinates list, given that stageCoordinates is populated by stageAppend

global stageCoordinates;
if stagePos > 0 && stagePos <= numel(stageCoordinates)
gotoFcScope = stageCoordinates{stagePos};
parsedAndValues = parseParamsForFunctions(gotoFcScope);
gotoStagePos(parsedAndValues.stagePos);
else
   disp('stage position is out of bounds'); 
end

end

