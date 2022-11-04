function [] = stopStreaming()
%STOPSTREAM stops sequence acquisition

global mmc;

mmc.stopSequenceAcquisition();


end

