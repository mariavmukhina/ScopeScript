function currExposure = getExposure()
%GETEXPOSURE get current exposure in ms
global mmc;
currExposure = double(mmc.getExposure());

end

