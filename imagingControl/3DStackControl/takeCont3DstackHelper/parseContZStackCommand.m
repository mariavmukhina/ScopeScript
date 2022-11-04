function dacInstructions = parseContZStackCommand(command,fcScope)
%PARSECONTZSTACKCOMMAND will generate the appropriate dac instructions
%given a command to do continuous z stack acquistion

% for continous acquisition you have a protocol for going up, then down
dacInstructions = cell(2,1);
% start the first part
dacInstructions{1} = constructPiezoDACcommands(command(1:2),fcScope);
% finish it off by removing the overlap and the last part. this tiles the
% dacInstructions perfectly for continous acquisition
if iscell(command{1})
    numWaves = numel(command{1});
else
    numWaves = 1;
end

holder.mergedZSteps = dacInstructions{1}.mergedZSteps(end-numWaves:-1:numWaves+1);
holder.mergedEnergyChannels = dacInstructions{1}.mergedEnergyChannels(numWaves+1:end-numWaves);
holder.N = numel(holder.mergedZSteps);
dacInstructions{2} = holder;
end

