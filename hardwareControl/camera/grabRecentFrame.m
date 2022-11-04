function lastFrame = grabRecentFrame()
%GRABRECENTFRAME Summary of this function goes here
%   Detailed explanation goes here

global mmc;

width = mmc.getImageWidth;
height = mmc.getImageHeight;
if mmc.getRemainingImageCount() > 0
    temp = mmc.getLastImage();
    lastFrame = reshape(typecast(temp,'uint16'),width,height);
else
    lastFrame = [];
end
end

