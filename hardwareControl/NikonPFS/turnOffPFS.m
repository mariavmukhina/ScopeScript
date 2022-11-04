function [] = turnOffPFS()
%WAITFORPFS Summary of this function goes here
%   Detailed explanation goes here

global ti2;
global liveStageONOFF

if liveStageONOFF == 0
    %ti2.iPFS_DM = 1;
    ti2.iPFS_SWITCH = 0;
    %ti2.iPFS_DM = 2;
end


end

