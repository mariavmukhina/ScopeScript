function [] = startStream()
%STARTSTREAM Summary of this function goes here
%   Detailed explanation goes here
stopStreaming();
global mmc;
mmc.startContinuousSequenceAcquisition(0);

end

