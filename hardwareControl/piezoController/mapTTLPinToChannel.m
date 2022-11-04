function arduinoPortVal = mapTTLPinToChannel(varargin)
%MAPCHANNELTOTTLPIN returns the mapping between LED channels (BF (ScopeLED) and PL (CoolLED)) and pins of the Arduino hardware controller, 
% so the data acquired with a TTL trigger are assigned to the correct channel

valueSet =   {'AllFourTTL', 'ChDTTL', 'ChCTTL', 'ChBTTL','ChATTL','ChABTTL','ChBCTTL','ChABCTTL','BrightFieldTTL','AllOnTTL'};
keySet = [1, 2, 4, 8, 16, 24, 12, 28, 64, 65];
if nargin == 0
    display(insertAStringBetweenCells(',',num2cell(keySet)));
    return;
else
   channel = varargin{1}; 
end

mapObj = containers.Map(keySet,valueSet);
if isvector(channel)
    arduinoPortVal = values(mapObj,num2cell(channel));
else
    arduinoPortVal = mapObj(channel);
end

end

