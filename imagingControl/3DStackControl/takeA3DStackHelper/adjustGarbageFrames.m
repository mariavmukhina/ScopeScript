function flattenedInstructions = adjustGarbageFrames(flattenedInstructions,fcScope)
%ADJUSTGARBAGEFRAMES adjusts the values or the  z stack values in the
%arduino controller to accomodate the fact that there are garbage frames
%after the streaming acquisition.  during garbage frames, the controller
%should ignore these pulses.  for my scmos camera, i have 1 lagging garbage
%frame, but there could be 2.  for generality you can program leading and
%lagging garbage frames
%
%fchang@fas.harvard.edu

leadingGarbageFrames = fcScope.leadingGarbageFrames;
laggingGarbageFrames = fcScope.laggingGarbageFrames;

if leadingGarbageFrames ~= 0
  flattenedInstructions.mergedZSteps = padarray(flattenedInstructions.mergedZSteps,[0,leadingGarbageFrames],flattenedInstructions.mergedZSteps(end),'pre');
  flattenedInstructions.mergedEnergyChannels = padarray(flattenedInstructions.mergedEnergyChannels,[0,leadingGarbageFrames],0,'pre');
  flattenedInstructions.feedForwardSteps = padarray(flattenedInstructions.feedForwardSteps,[0,leadingGarbageFrames],0,'pre');
end

if laggingGarbageFrames ~= 0
  flattenedInstructions.mergedZSteps = padarray(flattenedInstructions.mergedZSteps,[0,laggingGarbageFrames],'replicate','post');
  flattenedInstructions.mergedEnergyChannels = padarray(flattenedInstructions.mergedEnergyChannels,[0,laggingGarbageFrames],0,'post');
  flattenedInstructions.feedForwardSteps = padarray(flattenedInstructions.feedForwardSteps,[0,laggingGarbageFrames],0,'post'); 
end



end

