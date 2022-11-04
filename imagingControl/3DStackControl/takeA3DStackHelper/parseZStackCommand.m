function [dacInstructions] = parseZStackCommand(command,fcScope)
%PARSEZSTACKCOMMAND assumes command is for a regular z stack aquisition.
dacInstructions = cell(numel(command)/2,1);

for i = 1:2:numel(command)
    [dacInstructions{(i-1)/2 + 1}] = constructPiezoDACcommands(command(i:i+1),fcScope);
end

end

