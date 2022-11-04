function [meanBkgnd,cameraVariance] = calibrateSensorDarkFrames(darkFrameFolder)
%CALIBRATESENSOR Summary of this function goes here
%   Detailed explanation goes here

darkFrames = getLocalFiles(darkFrameFolder,'tif');
darkFrames = getOrderedListFromMatch(darkFrames,'t[0-9]+','ascend');
darkFrames = darkFrames{1}.subMatch;
[meanBkgnd,~,cameraVariance] = onlineMeanVarianceCalc(darkFrames);
end
