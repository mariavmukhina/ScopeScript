function [  ] = moveNanocubeY(Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global E727;
E727.MOV('2',Y)
pause(0.5);
newPosition = E727.qPOS('2');
disp(['new Y position is ' num2str(newPosition)]);

end

