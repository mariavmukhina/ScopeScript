function [stack,varargout] = getStream(n)
%GETSTREAM runs acquisition of zstacks defined in fcScope in scopeParams.m
%If liveStage is on, it also initiates recording of z positions of the stage during each frame acquisition
global mmc;
global liveStageONOFF

width = mmc.getImageWidth;
height = mmc.getImageHeight;
stack   = zeros(width,height,n,'uint16');
mmc.prepareSequenceAcquisition(mmc.getCameraDevice);
mmc.startSequenceAcquisition(n, 0, false);
j = 0;
curr_time = clock;

% prepare liveStage or fastLiveStage
if liveStageONOFF == 1
    ZStagePositions = zeros(n,1);
    ZtimeStamps = zeros(n,6);
elseif liveStageONOFF > 1
    if mmc.getCameraDevice == 'Andor'
    	imagingInterval = str2double(mmc.getProperty(mmc.getCameraDevice,'ActualInterval-ms'));
    elseif mmc.getCameraDevice == 'C13440'
    	imagingInterval = str2double(mmc.getProperty(mmc.getCameraDevice,'Exposure'))+ str2double(mmc.getProperty(mmc.getCameraDevice,'ReadoutTime'));
    end
end

while(mmc.getRemainingImageCount() > 0 || ...
        mmc.deviceBusy(mmc.getCameraDevice()) || j ~= n)
    if (mmc.getRemainingImageCount() > 0)
            %track z stage position during aquisition with resolution more than 1 recording per frame
            if liveStageONOFF > 1
                liveStage(imagingInterval,j);
            end
            j = j+1;
            if liveStageONOFF == 1
                [ZStagePositions(j,:),ZtimeStamps(j,:)] = fastLiveStage();
            end
			stack(:,:,j) = reshape(typecast(mmc.popNextImage(),'uint16'),width,height);
    end
end
mmc.stopSequenceAcquisition();
timestamps.initialTime = curr_time;
timestamps.dt = str2double(mmc.getProperty(mmc.getCameraDevice,'ReadoutTime'));
if liveStageONOFF == 1
    saveFastLiveStageOutput(ZStagePositions,ZtimeStamps);
end
if nargout == 2
   varargout{1} = timestamps; 
end
end

