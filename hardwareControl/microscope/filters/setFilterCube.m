function [] = setFilterCube(channel)
%SETFILTERCUBE rotates the filter cube set by channel
% this function also checks to make sure you type in the right channel

global ti2;
filterCubes = printAvailableFilterCubes();
cubesNumbers = {'1','2','3','4','5','6'};
cubesMap = containers.Map(filterCubes,cubesNumbers);
if sum(strcmp(channel,filterCubes)) > 0
   ti2.iTURRET1POS = str2num(cubesMap(channel));
else
   error('channel name not found'); 
end


end

