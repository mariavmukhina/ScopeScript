function [] = calibrateSensorGain(fileLocationMeanVar,fileLocationDark)
%CALIBRATESENSORGAIN given the folder location for the mean variance photon
%transfer titration and dark frame folder, this function will calculate the
% gain, offset, and noise per pixel

darkFrameFolder = fileLocationDark; 
meanVarFolder = fileLocationMeanVar;

meanVars = getLocalFiles(meanVarFolder,'tif');
daListOrganized = getOrderedListFromMatch(meanVars,'_t[0-9]+','ascend');
nEnergies = numel(daListOrganized);
genericMeta = getMetaDataOfTifs(daListOrganized{1}.subMatch{1});
width = genericMeta.width;
height = genericMeta.height;

[path] = getParentDirecotory(meanVarFolder);
savePath = [path filesep 'calibrationResult'];
saveFitsPath = [savePath filesep 'fits'];
[~,~,~] = mkdir(savePath);
[~,~,~] = mkdir(saveFitsPath);

% initialize mean and variance frames for each energy
energyMeanFrames = zeros(width,height,nEnergies);
energyVarFrames = zeros(width,height,nEnergies);
energyVals = zeros(nEnergies,1);
% calculate online mean variance for each energy
for i = 1:nEnergies
    display(['processing energy ' num2str(i)]);
    energyFrameList = daListOrganized{i}.subMatch;
    [meanSig,~,sigVariance] = onlineMeanVarianceCalc(energyFrameList);
    energyMeanFrames(:,:,i) = meanSig;
    energyVarFrames(:,:,i) = sigVariance;
    energyString = regexp(daListOrganized{i}.name,'_e[0-9]+','match');
    energyString = energyString{1};
    energyVals(i) = str2double(energyString(3:end));
end
save([savePath filesep 'intermediateEnergy.mat'],'energyMeanFrames','energyVarFrames');

% calculate dark frames
display('processing dark frames...');
[meanBkgnd,cameraVariance] = calibrateSensorDarkFrames(darkFrameFolder);
save([savePath filesep 'intermediateBkgnd.mat'],'meanBkgnd','cameraVariance');
% calculate gain from variancerun
gain(width,height) = 0;
gainRobust(width,height) = 0;
intercept(width,height) = 0;
standErrorGAIN(width,height) = 0;
meanSqError(width,height) = 0;
% setup needed matrix
B = energyMeanFrames;
A = energyVarFrames;

figure;
% [~,index] = sort(energyVals);
step = round(width*height/100);
for i = width+10:step:width*height
    [xi,yi] = ind2sub(size(energyMeanFrames(:,:,1)),i);
    x = B(xi,yi,:);
    y = A(xi,yi,:);
    x = x(:);
    y = y(:);
    [~,index] = sort(x);
    x = x(index);
    y = y(index);
    hold on;
    plot(x,y);
end
title('Sub-sample of Mean Variance Titrations');
xlabel('Mean Intensity [ADU]');
ylabel('Mean Varience [ADU]');

for k = 2:8 % use it if you want to get rid of saturated frames
    Acropped(:,:,k) = A(:,:,k);
    Bcropped(:,:,k) = B(:,:,k);
end

parfor i = 1:width
    display(['columne ' num2str(i)]);
    for j = 1:height
        %display(j);
        for k = 2:8
            Apixel = Acropped(i,j,:);
            Bpixel = Bcropped(i,j,:);
            Apixel = Apixel(:);
            Bpixel = Bpixel(:);
            BpixelLiner = Bpixel;
    %       weights = 1./Bpixel;
            Bpixel = [ones(length(Bpixel(:)),1) Bpixel(:)];
            % in units of ADU/e
    %       [fit,stdx,mse] = lscov(Bpixel,Apixel,weights);
            [fit,stdx,mse] = lscov(Bpixel,Apixel);
            % robust estimation
            dlr = fitlm(BpixelLiner,Apixel,'RobustOpts','on');
            robustEstimate = dlr.Coefficients.Estimate;
            gainRobust(i,j) = robustEstimate(2);
            gain(i,j) = fit(2);
            intercept(i,j) = fit(1);
            standErrorGAIN(i,j) = stdx(2);
            meanSqError(i,j) = mse;
        end
    end
end
save([savePath filesep 'intermediateGain.mat'],'gainRobust','gain','meanSqError','standErrorGAIN','intercept');
cameraVarianceInElectrons = cameraVariance./(gain.^2);

figure;
histogram(cameraVarianceInElectrons,10000);
title('Readout Noise Distribution');
xlabel('Readout Noise [electrons]');
ylabel('Frequency');
axis([0 6 0 2.5e5]);

%figure;
%histogram(cameraVarianceInElectronsOFF,400000,'BinLimits',[0,max(max(cameraVarianceInElectronsOFF))]);
%hold on;
%histogram(cameraVarianceInElectronsON,400000,'BinLimits',[0,max(max(cameraVarianceInElectronsOFF))]);
%title('Readout Noise Distribution');
%xlabel('Readout Noise [electrons]');
%ylabel('Frequency');
%axis([0 5 0 6e5]);

readoutNoiseRMS = rms(rms(cameraVarianceInElectrons));

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

