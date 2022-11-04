function [] = writeZFuncData(mergedZSteps,mergedEnergyChannels,feedForwardSteps)
%WRITEZFUNCDATA updates piezo controller with the parameters set by the
%arguments in fcScope
%
% fchang@fas.harvard.edu

% write z func data incrementally
for i = 1:numel(mergedZSteps)
    zFuncDacIndex = i-1;
    izFuncDAC = mergedZSteps(i);
    waveLength = mergedEnergyChannels(i);
    ikickItUpDelay = feedForwardSteps(2,i);
    ikickItUpDelta = feedForwardSteps(1,i);
    islowItDownDelay = feedForwardSteps(4,i);
    islowItDownDelta = feedForwardSteps(3,i);
    input = ['w' num2str( zFuncDacIndex) ',' ...
        num2str(izFuncDAC) ',' ...
        num2str(waveLength)  ',' ...
        num2str(ikickItUpDelay) ',' ...
        num2str(ikickItUpDelta) ',' ...
        num2str(islowItDownDelay) ',' ...
        num2str(islowItDownDelta)];
    write2ArduinoController(input);
end
% update start and ending increments for zindex
setZstartEndDAC(0,numel(mergedZSteps)-1);
end

