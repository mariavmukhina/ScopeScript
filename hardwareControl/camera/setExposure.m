function [] = setExposure(exposure)
%SETEXPOSURE sets the camera exposure

global mmc;
global liveStageONOFF;

if mmc.getCameraDevice == 'C13440'
    if liveStageONOFF == 1 % for fastLiveStage(), do not add sensor readout time
        mmc.setExposure(exposure);
    else
        mmc.setExposure(exposure+getSensorReadOutTime); 
    end
elseif mmc.getCameraDevice == 'Andor'
    mmc.setExposure(exposure);
end

end

