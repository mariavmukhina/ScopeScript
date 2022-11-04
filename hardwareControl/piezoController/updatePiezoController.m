function [] = updatePiezoController(flattenedInstructions)
%updatePiezoController given a zStack command, this function will update the
%arduino controller accordingly
%     izFuncDAC = zFuncDAC(zFuncIndex);
%     waveLength = zWavelengths{numel(zWavelengths)- mod(i,numel(zWavelengths))};
%     ikickItUpDelay = kickItUpDelay(zFuncIndex)*(mod(i,numel(zWavelengths))>0);
%     ikickItUpDelta = kickItUpDelta(zFuncIndex)*(mod(i,numel(zWavelengths))>0);
%     islowItDownDelay = slowItDownDelay(zFuncIndex)*(mod(i,numel(zWavelengths))>0);
%     islowItDownDelta = slowItDownDelta(zFuncIndex)*(mod(i,numel(zWavelengths))>0);

% stop arduino controller
disp('----updatePiezoController()----');
ttlPiezo();
disp('writing to piezo controller...');
% update arduino controller
mergedZSteps            = flattenedInstructions.mergedZSteps;
mergedEnergyChannels    = flattenedInstructions.mergedEnergyChannels;
feedForwardSteps        = flattenedInstructions.feedForwardSteps;
writeZFuncData(mergedZSteps,mergedEnergyChannels,feedForwardSteps);
end

