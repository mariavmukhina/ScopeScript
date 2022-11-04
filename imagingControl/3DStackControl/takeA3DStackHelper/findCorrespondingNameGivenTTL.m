function zStackName = findCorrespondingNameGivenTTL(commands,TTLtriggerName)
%FINDCORRESPONDINGNAMEGIVENTTL given commands and TTL trigger name this
%function will return the corresponding zStackname associated with
%TTLtriggername
% 
% this function is designed for the two cases 
% {'zStack1','TTLtrigger1','zStack2','TTLtrigger2'}
% or
% {{'zStack1','zStack1'},{'TTLtrigger1','TTLtrigger2'},'zStack3','TTLtrigger3'};

flattenCommands = flattenCellArray(commands);

index = find(strcmp(flattenCommands,TTLtriggerName));
if numel(index) ~= 1
    error('could not find TTL trigger');
end

if strfind(flattenCommands{index-1},'zStack')
    zStackName = flattenCommands{index-1};
elseif strfind(flattenCommands{index-2},'zStack')
    zStackName = flattenCommands{index-2};
else
   error('could not find corresponding zStack on TTL trigger'); 
end
end

