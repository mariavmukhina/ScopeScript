function [dacInstructions] = constructPiezoDACcommands(command,fcScope)
%CONSTRUCTPIEZODACCOMMANDS given z stack command in fcScope, this function
%will construct the actual DAC instructions that the arduino controller
%will execute

%   Detailed explanation goes here
% extract parameters given command
[zStackParamRoot,zStackLEDTTL] = extractZParamsForCommand(command);
% generate z stack instructions from parameters
[mergedZSteps,mergedEnergyChannels,interleavedChannel] = genDacInstructionsFromZParams(zStackParamRoot,zStackLEDTTL,fcScope);

dacInstructions.mergedZSteps = mergedZSteps;
dacInstructions.mergedEnergyChannels = mergedEnergyChannels;
dacInstructions.N = numel(mergedZSteps);
dacInstructions.params = interleavedChannel;
end

