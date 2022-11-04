function flattenedInstructions = populateFeedForwardParams(flattenedInstructions,fcScope)
%POPULATEFEEDFOWARDPARAMS given zStep increments, populate the feed forward
%parameters given fcScope parameters
mergedZSteps = flattenedInstructions.mergedZSteps;
% get all feed forward params, which are specified as 'ff' 
ffParams = keepCertainStringsUnion(properties(fcScope),'^ff[0-9]+_dz');
dzs      = get(fcScope,ffParams);
% zIndex refers to the next step to be taken.  
mergedZSteps = circshift(mergedZSteps,[0,-1]);
% get jump sizes given a z step protocol
jump0  = mergedZSteps(1) - mergedZSteps(end);
jumpSizes = [jump0 diff(mergedZSteps)];
% populate feedForwardSteps given ff params
[idxBinary,idxOfdzs] = ismember(jumpSizes,cell2mat(dzs));
feedForwardSteps = zeros(4,numel(idxBinary));
% populate deltaUp
feedForwardSteps(1,idxBinary) = arrayfun(@(x) get(fcScope,['ff' num2str(x) '_deltaUp']),idxOfdzs(idxBinary));
% populate delayUp
feedForwardSteps(2,idxBinary) = arrayfun(@(x) get(fcScope,['ff' num2str(x) '_delayUp']),idxOfdzs(idxBinary));
% populate deltaDown
feedForwardSteps(3,idxBinary) = arrayfun(@(x) get(fcScope,['ff' num2str(x) '_deltaDown']),idxOfdzs(idxBinary));
% populate delay Down
feedForwardSteps(4,idxBinary) = arrayfun(@(x) get(fcScope,['ff' num2str(x) '_delayDown']),idxOfdzs(idxBinary));
% handle missing jumpSizes
missingFeedForwards = jumpSizes(~idxBinary);
% missingFeedForwards = missingFeedForwards(missingFeedForwards > 0);
if any(missingFeedForwards)
   warning(['missing jump parameters: ' mat2str(missingFeedForwards)]);
end
flattenedInstructions.feedForwardSteps = feedForwardSteps;
end

