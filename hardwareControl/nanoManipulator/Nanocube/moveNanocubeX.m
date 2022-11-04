function [  ] = moveNanocubeX(X)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global E727;
E727.MOV('1',X)
pause(0.5);
newPosition = E727.qPOS('1');
disp(['new X position is ' num2str(newPosition)]);

end

