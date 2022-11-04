function filePath = runDarkFrameCalibration()
%RUNDARKFRAMECALIBRATION gets dark frames to calculate offset and camera
%noise
%
% fchang@fas.harvard.edu
global mmc;
fcScope = scopeParams;
numFrames = fcScope.numDarkFrames;
darkPath = fcScope.darkFramesPath;
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
filePath = [tempPath(1:end-1) '-' stringID '-' darkPath];
filename = [filePath 'darkFrame'];
setBrightFieldTTL('Red',0);
turnOffAllEpiChannels();
holdPiezoBF();
% setRightLightPath();
closeTurretShutter();
stopStreaming();
display(['using exposure time: ' num2str(getExposure)  'ms']);
waitForSystem();
byBlocksOf = fcScope.streamInBlocksOf;
display(['getting ' num2str(numFrames)  ' dark frames by blocks of ' num2str(byBlocksOf)]);
[~,~,~] = mkdir(filePath);
for j = 0:byBlocksOf:numFrames
    writeStream(byBlocksOf,filename,j);
end
unlockBrightFieldLED();
end

