function [] = calibrateHelper()

width = 2048;
height = 2048;
energyVarFrames = evalin('base','energyVarFrames');
energyMeanFrames = evalin('base','energyMeanFrames');
cameraVariance = evalin('base','cameraVariance');
meanBkgnd = evalin('base','meanBkgnd');
gainRobust = evalin('base','gainRobust');
gain = evalin('base','gain');
intercept = evalin('base','intercept');
standErrorGAIN = evalin('base','standErrorGAIN');
meanSqError = evalin('base','meanSqError');

[path] = 'E:\fcNikon\fcTest\20171114-ID300458-CoolerAIR-ROI2048x2048-DefectCorrOFF-cameraCalibration';
savePath = [path filesep 'calibrationResult'];
saveFitsPath = [savePath filesep 'fits'];
[~,~,~] = mkdir(savePath);
[~,~,~] = mkdir(saveFitsPath);


%h1 = figure('visible','off');
%figure;
% [~,index] = sort(energyVals);
%step = round(width*height/100);
%for i = width+10:step:width*height
%    [xi,yi] = ind2sub(size(energyMeanFrames(:,:,1)),i);
%    x = energyMeanFrames(xi,yi,:);
%    y = energyVarFrames(xi,yi,:);
%    x = x(:);
%    y = y(:);
%    [~,index] = sort(x);
%    x = x(index);
%    y = y(index);
%    hold on;
%    plot(x,y);
%end
%title('Sub-sample of Mean Variance Titrations');
%xlabel('Mean Intensity [ADU]');
%ylabel('Mean Varience [ADU]');
%axis tight;
%print(h1,[saveFitsPath filesep 'photonTransferCurve'],'-dpng');

cameraVarianceInElectrons = cameraVariance./(gain.^2);

figure;
%h2 = figure('visible','off');
histogram(cameraVarianceInElectrons,10000);
title('Readout Noise Distribution');
xlabel('Readout Noise [electrons]');
ylabel('Frequency');
axis([0 6 0 2.5e5]);
%print(h2,[saveFitsPath filesep 'readoutNoiseDistribution'],'-dpng');

for i = 1:width
   columnRMS = rms(cameraVarianceInElectrons);
end
for j = 1:height
   readoutNoiseRMS = rms(columnRMS);
end

global mmc;
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

scanMode = mmc.getProperty('C13440','ScanMode');
if strcmp(scanMode,'1')
   cameraSpeed = 'SlowScan';
else
   cameraSpeed = 'FastScan';
end

sensorCorrection = char(mmc.getProperty('C13440','DEFECT CORRECT MODE'));

stringID = ['ID' stringID '-Cooler'  coolerType '-' ROIstring '-' cameraSpeed '-sensorCorrection' sensorCorrection];% save([savePath filesep 'calibration-' stringID '-' returnDate() '.mat'],'intercept','gain','A','B','meanBkgnd','cameraVarianceInElectrons','cameraVariance','energyMeanFrames','energyVarFrames','energyVals');
save([savePath filesep 'calibration-' stringID '-' returnDate() '.mat'],'meanBkgnd','cameraVarianceInElectrons','cameraVariance','meanSqError','standErrorGAIN','energyMeanFrames','energyVarFrames','gainRobust','gain','intercept','readoutNoiseRMS');

end

