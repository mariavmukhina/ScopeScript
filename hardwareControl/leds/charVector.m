function [charCommand] = charVector(hexstring)
%CHARVECTOR returns HEX command in mmcorej.CharVector format
decCommand = hex2dec(hexstring);

charCommand = mmcorej.CharVector();
for k=1:length(decCommand)
charCommand.add(char(decCommand(k)));
end
end

