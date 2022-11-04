function flattenedInstructions = concatCellArrayOfDacInstructions(dacInstructions)
%CONCATCELLARRAYOFDACINSTRUCTIONS dacInstructions is a cell array of dac
%instructions that need to be concatenated so one stream can execute

for i = 2:numel(dacInstructions)
   dacInstructions{1}.mergedZSteps = [dacInstructions{1}.mergedZSteps dacInstructions{i}.mergedZSteps];
   dacInstructions{1}.mergedEnergyChannels = [dacInstructions{1}.mergedEnergyChannels dacInstructions{i}.mergedEnergyChannels];
   dacInstructions{1}.N = dacInstructions{1}.N + dacInstructions{i}.N;
end
flattenedInstructions.mergedZSteps = dacInstructions{1}.mergedZSteps;
flattenedInstructions.mergedEnergyChannels = dacInstructions{1}.mergedEnergyChannels;
flattenedInstructions.N = dacInstructions{1}.N;

end

