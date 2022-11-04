function [] = printScopeSettings()
%GETCURRENTSETTINGS Summary of this function goes here
%   Detailed explanation goes here

fprintf('filter:\t\t%s\n',getCurrentFilterCube);
fprintf('LED:\t\t');printCurrentLEDState();
currROI = getROI();
fprintf('ROI:\t\t[x0,y0,width,height]->[%i,%i,%i,%i]\n',currROI(1),currROI(2),currROI(3),currROI(4));
fprintf('exposure(ms) %f\n',getExposure());
end

