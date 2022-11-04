function [readOutTime] = getSensorReadOutTime()
%GETSENSORREADOUTTIME returns frame read out time in ms
global mmc;
if mmc.getCameraDevice == 'C13440'
    readOutTime = str2double(mmc.getProperty(mmc.getCameraDevice,'ReadoutTime'));
elseif mmc.getCameraDevice == 'Andor'
    readOutTime = str2double(mmc.getProperty(mmc.getCameraDevice,'ReadoutTime'));
end
end

