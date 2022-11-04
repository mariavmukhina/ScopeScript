function [  ] = currPosNanocubeZ()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global E727;
currPosition = E727.qPOS('3');
disp(['current Z position is ' num2str(currPosition)]);

end

