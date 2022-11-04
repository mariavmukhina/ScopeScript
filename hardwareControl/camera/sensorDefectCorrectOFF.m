function [] = sensorDefectCorrectOFF()
%SENSORDEFECTCORRECTOFF Summary of this function goes here
%   Detailed explanation goes here

global mmc;
if mmc.getCameraDevice == 'C13440'
    disp('C13440 defect correct mode is set to off');
    mmc.setProperty('C13440','DEFECT CORRECT MODE','OFF');
end
end

