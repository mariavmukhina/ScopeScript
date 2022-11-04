function output = executeTakeCont3DStack(argumentList,fcScope)
%EXECUTETAKECONT3DSTACK Summary of this function goes here
%   Detailed explanation goes here

if numel(argumentList)== 3 && isnumeric(argumentList{end})
    %if number of elements in command is 3, and the last element is a
    %number, then it is a continuous zstack protocol
    streamNFrames = argumentList{end};
    dacInstructions = parseContZStackCommand(argumentList,fcScope);
    % concat the dacInstructions into one instruction
    flattenedInstructions = concatCellArrayOfDacInstructions(dacInstructions);
    % populate the feedForwardParams
    flattenedInstructions = populateFeedForwardParams(flattenedInstructions,fcScope);
    % mergedZSteps need to be circulaly shifted once to the left so it is ready
    % in the correct state
    flattenedInstructions.mergedZSteps = circshift(flattenedInstructions.mergedZSteps,[0,-1]);
    flattenedInstructions.commands = argumentList;
    flattenedInstructions.dacInstructions = dacInstructions;
    updatePiezoController(flattenedInstructions);
    output = executeContZCommand(flattenedInstructions,fcScope,streamNFrames);
else
    error('format of argumentList is not correct');
end
end

