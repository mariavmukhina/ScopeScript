function [] = stopWaveGenerator()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global E727;
global liveStageONOFF;
if liveStageONOFF > 0
    assignedWavetables = E727.qWSL([1 2 3]); % check which generators have assigned wavetables
    for i = 1:3
        if assignedWavetables(i) == 1
            E727.WGO(i,0);
        end
    end

%move to initial position defined in scopeParams
moveToInitialPosition('scopeParams')
end
end

