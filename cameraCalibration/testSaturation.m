function filePath = testSaturation()
%RUNPHOTONTRANSFERCALIBRATION will to execute a mean variance calibration
%of the sensor using the brightfield LED as the illumination source
%
% fchang@fas.harvard.edu

fcScope = scopeParams();
exposure = max(fcScope.exposureTitration)
brightFieldLEDChannel = fcScope.brightFieldLEDChannel;
fluorescenceChannel   = fcScope.fluorescenceChannel;
energy = 3;

% setup file name
% filePath = [returnPath(fcScope) filesep meanVariancePath];
% [~,~,~] = mkdir(filePath);

% setup microscope
ttlPiezo();
fcScope.cameraPath();
setExposure(exposure);
stopStreaming();
setFilterCube(fluorescenceChannel);
closeTurretShutter();

% initialize brightfield LED
setBrightFieldTTL(brightFieldLEDChannel,energy);
oldROI = getROI();
clearROI();
doLive(oldROI);
setROI(oldROI);
% 
% display(['acquiring ' num2str(numFrames)  ' mean variance frames by blocks of ' num2str(byBlocksOf)]);
% 
% % do meanVariance photon transfer curve using brightfield LED
% waitForSystem();
% for i=energies
%     sendText('photonTransferCalibration: ',num2str(i));
%     display(['measuring: energy ' num2str(i)]);
%     filename = [filePath 'meanVariance' '_e' num2str(i)];
%     setBrightFieldTTL(brightFieldLEDChannel,i);
%     waitForSystem();
%     for j = 0:byBlocksOf:numFrames
%         writeStream(byBlocksOf,filename,j);
%     end
% end
% 
% % close shutters and message that experiment is finished
% closeDiaShutter();
% closeEpiShutter();
turnOffAllLEDs();
unlockBrightFieldLED();
end

