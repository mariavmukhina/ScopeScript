function [  ] = currPosNanocubeX()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global E727;
currPosition = E727.qPOS('1');
disp(['current X position is ' num2str(currPosition)]);

end

