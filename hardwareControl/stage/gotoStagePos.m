function [] = gotoStagePos(stagePos)
%GOTOSTAGEPOS moves the microscope stage to selected XY position
global ti2;
if ~isempty(stagePos)
    ti2.XPosition.Value = stagePos.X;
    ti2.YPosition.Value = stagePos.Y;
end

end

