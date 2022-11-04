function [] = updateChannelGivenCommand(setChannel)
%UPDATECHANNELGIVENCOMMAND when given a list of setupChannel arguments, it
%will sequentially execute them in order
% {{'1-cy5',100},{'BlueBrightField',100}};

if strcmp(setChannel,'none')
    return;
end
for i = 1:numel(setChannel)
   argument = setChannel{i};
   setupChannel(argument{:});
end


