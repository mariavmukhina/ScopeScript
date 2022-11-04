function filePath = runPhotonTransferCalibration()
%RUNPHOTONTRANSFERCALIBRATION will to execute a mean variance calibration
%of the sensor using the brightfield LED as the illumination source
%
% fchang@fas.harvard.edu

global mmc;
fcScope = scopeParams();
energy = 10; % with a paper cup worn on the objective
numFrames = fcScope.numEnergyTitrationFrames;
meanVariancePath = fcScope.meanVariancePath;
byBlocksOf = fcScope.streamInBlocksOf;
brightFieldLEDChannel = fcScope.brightFieldLEDChannel;
fluorescenceChannel   = fcScope.fluorescenceChannel;
exposures = fcScope.exposureTitration;

% setup file name
tempPath = returnPath(fcScope);
stringID = char(mmc.getProperty('C13440','CameraID'));
stringID = stringID(6:end);
width = getWidthOfROI();
height = getHeightOfROI();
ROIstring = ['ROI' num2str(width) 'x' num2str(height)];
try
   coolerType = char(mmc.getProperty('C13440','Sensor Cooler')); 
catch
    coolerType = 'AIR';
end
stringID = ['ID' stringID '-Cooler'  coolerType '-' ROIstring];
filePath = [tempPath(1:end-1) '-' stringID '-' meanVariancePath];
[~,~,~] = mkdir(filePath);

% setup microscope
ttlPiezo();
fcScope.cameraPath();
stopStreaming();
setFilterCube(fluorescenceChannel);
closeTurretShutter();

display(['acquiring ' num2str(numFrames)  ' mean variance frames by blocks of ' num2str(byBlocksOf)]);
% setExposure(fcScope.energyTitrationExposure);
% do meanVariance photon transfer curve using brightfield LED
waitForSystem();
% for i=energies
%     display(['measuring: energy ' num2str(i)]);
%     filename = [filePath 'meanVariance' '_e' num2str(i)];
%     setBrightFieldTTL(brightFieldLEDChannel,i);
%     waitForSystem();
%     for j = 0:byBlocksOf:numFrames
%         writeStream(byBlocksOf,filename,j);
%     end
% end
% initialize brightfield LED
setBrightFieldTTL(brightFieldLEDChannel,energy);
for i=1:numel(exposures)
%     display(['measuring: energy ' num2str(i)]);
    filename = [filePath 'meanVariance' '_e' num2str(i)];
    setExposure(exposures(i));
    waitForSystem();
    for j = 0:byBlocksOf:numFrames
        writeStream(byBlocksOf,filename,j);
    end
end

unlockBrightFieldLED();
% close shutters and switch off all LEDs
turnOffAllLEDs();
closeTurretShutter();

end

