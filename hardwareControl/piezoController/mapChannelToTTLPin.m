function arduinoPortVal = mapChannelToTTLPin(varargin)
%MAPCHANNELTOTTLPIN returns the mapping between LED channels (BF (ScopeLED) and PL (CoolLED)) and pins of the Arduino hardware controller, 
% so the arduino triggers the correct leds for the corresponding channel

keySet =   {'AllFourTTL', 'ChDTTL', 'ChCTTL', 'ChBTTL','ChATTL','ChABTTL','ChBCTTL','ChABCTTL','BrightFieldTTL','AllOnTTL'};
valueSet = [1, 2, 4, 8, 16, 24, 12, 28, 64, 65];
if nargin == 0
    display(insertAStringBetweenCells(',',keySet));
    return;
else
   channel = varargin{1}; 
end

mapObj = containers.Map(keySet,valueSet);
if iscell(channel)
    arduinoPortVal = cellfun(@(x) mapObj(x),channel);
else
    arduinoPortVal = mapObj(channel);
end

end

