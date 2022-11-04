function [mergedZSteps,mergedEnergyChannels,interleavedChannel] = genDacInstructionsFromZParams(zStackParamRoot,zStackEnergy,fcScope)
%GETDACINSTRUCTIONSFROMZPARAMS will generate the values that will be
%programmed into the arduino hardware controller given the zstack
%parameters
[interleavedChannel,interleavedEnergyParams] = genInterleavedChannels(zStackParamRoot,zStackEnergy,fcScope);
[mergedZSteps,mergedEnergyChannels] = mergeChannel(interleavedChannel,interleavedEnergyParams);
mergedEnergyChannels = mapChannelToTTLPin(mergedEnergyChannels);



end

