function [  ] = currPosNanocubeY()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global E727;
currPosition = E727.qPOS('2');
disp(['current Y position is ' num2str(currPosition)]);

end

