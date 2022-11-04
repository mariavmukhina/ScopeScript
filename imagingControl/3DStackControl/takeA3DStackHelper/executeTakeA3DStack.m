function [zCommandOutput] = executeTakeA3DStack(argumentList,fcScope)
%EXECUTETAKEA3DSTACK will
% 1) update piezo controller
% 2) execte 3d stack
% 3) parse data
%
% argumentList can consist of
% create one zstack
% {'zStack1','TTLtrigger'}
% create two zstacks on one stream
% {'zStack1','TTLtrigger1','zStack2','TTLtrigger2',...};
% create an interleaved zstack with two triggers per slice
% {{'zStack1','zStack1'},{'TTLtrigger1','TTLtrigger2},...};
%
% 'zStack1' parameters specify a zstack and is defined in fcScope as
% zStack1_N
% zStack1_dz
% zStack1_z0


% create dacInstructions from the simple argumentList by extracting the
% parameters from fcScope
dacInstructions = parseZStackCommand(argumentList,fcScope);
% concat the dacInstructions into one instruction
flattenedInstructions = concatCellArrayOfDacInstructions(dacInstructions);
% populate the feedForwardParams
flattenedInstructions = populateFeedForwardParams(flattenedInstructions,fcScope);
% mergedZSteps need to be circulaly shifted once to the left so it is ready
% in the correct state
flattenedInstructions.mergedZSteps = circshift(flattenedInstructions.mergedZSteps,[0,-1]);
% adjust for garbage frames since streaming acquisition can leave a frame
% here and there.  for my setup, i get one extra frame at the tailing end.
flattenedInstructions = adjustGarbageFrames(flattenedInstructions,fcScope);
% append commands and piezo instructions to flattenedInstructions
flattenedInstructions.commands = argumentList;      
flattenedInstructions.dacInstructions = dacInstructions;
updatePiezoController(flattenedInstructions);
[zCommandOutput] = executeZCommand(flattenedInstructions,fcScope);
end

