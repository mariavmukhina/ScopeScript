function [  ] = moveNanocubeZ(Z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global E727;
E727.MOV('3',Z)
pause(0.5);
newPosition = E727.qPOS('3');
disp(['new Z position is ' num2str(newPosition)]);

end

