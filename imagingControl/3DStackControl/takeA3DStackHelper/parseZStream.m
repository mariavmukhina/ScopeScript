function zCommandOutput = parseZStream(streamAcq,flattenedInstructions,fcScope)
%PARSEZSTREAM parses the z stream from streamAcq given by
%flattenedInstructions.  
%
% note! this function assumes that each stack is uniquely identified by its TTLtrigger.  

commands = flattenedInstructions.commands;
uniqueWavelengths = unique(flattenedInstructions.mergedEnergyChannels);
uniqueWavelengths(uniqueWavelengths==0) = [];
zCommandOutput = cell(numel(uniqueWavelengths),1);
for i =1:numel(uniqueWavelengths)
   % parse data by TTL triggers
   zCommandOutput{i}.data = streamAcq(:,:,flattenedInstructions.mergedEnergyChannels == uniqueWavelengths(i)); 
   % given TTL trigger, get the meta info
   zMeta.TTLtrigger = mapTTLPinToChannel(uniqueWavelengths(i));
   zMeta.zStackName = findCorrespondingNameGivenTTL(commands,zMeta.TTLtrigger);
   zParams = genInterleavedChannels(zMeta.zStackName,zMeta.TTLtrigger,fcScope);
   zMeta.zParams    = zParams{1};
   zCommandOutput{i}.zMeta = zMeta;
end

