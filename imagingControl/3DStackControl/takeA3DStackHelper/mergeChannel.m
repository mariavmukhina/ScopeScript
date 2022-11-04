function [mergedZSteps,mergedEnergyChannels] = mergeChannel(interleavedChannel,interleavedEnergy)
%MERGECHANNEL will take the parameters from interleaveChannel, which is in
%the form of interleaveChannel{1}.N .dz .z0 and merge it at ordered
%positions.  
% the principle vector is the first one, and the additional vectors will be
% sorted according to this one
numChannels = numel(interleavedChannel);
zVectHolder         = cell(numChannels,1);
energyChannelHolder = cell(numChannels,1);
for i = 1:numChannels
    currChannel = interleavedChannel{i};
    zVectHolder{i}   = convertZParamsToVector(currChannel.N,currChannel.z0,currChannel.dz);
    energyChannelHolder{i} = repmat({interleavedEnergy{i}.energyChannel},1,currChannel.N);
end

% check directionality of princple z vector and make sure the others have
% the same directionality
principleSign = interleavedChannel{1}.dz;
productSign = prod(cellfun(@(x) x.dz,interleavedChannel));
if sign(principleSign) ~= sign(productSign)
    error('principle channel direction is not the same as rest');
end
if principleSign > 0
    sortBy = 'ascend';
else
    sortBy = 'descend';
end
energyChannels = [energyChannelHolder{:}];
[mergedZSteps,sortedIndex] = sort([zVectHolder{:}],2,sortBy);
mergedEnergyChannels = energyChannels(sortedIndex);

end

