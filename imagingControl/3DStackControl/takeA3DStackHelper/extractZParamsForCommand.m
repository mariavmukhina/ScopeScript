function [zStackParamRoot,zStackEnergy] = extractZParamsForCommand(command)
%EXTRACTZPARAMSFORCOMMAND will parse a zstack command in a given protocol 
    currZStack = command;
    zStackParamRoot = currZStack{1};
    zStackEnergy  = currZStack{2};
end

