function filePath = genPhotonTransferCalibration()
%GENPHOTONTRANSFERCALIBRATION Summary of this function goes here
%   Detailed explanation goes here
fcScope = scopeParams();
energies = fcScope.energyTitration;
numFrames = fcScope.numEnergyTitrationFrames;
meanVariancePath = fcScope.meanVariancePath;
sigma = fcScope.syn_sigma;
offset = fcScope.syn_offset;
xSize = fcScope.syn_xSize;
ySize =fcScope.syn_ySize;
gain = fcScope.syn_gain;
fullWell = fcScope.syn_fullWell;
% setup file name
filePath = [returnPath(fcScope) filesep meanVariancePath];

fullWellMax = fullWell*0.7;
lambdaDelta = fullWellMax / max(energies);

parfor i=energies
    filename = [filePath 'meanVariance' '_e' num2str(i)];
    display(filename);
    makeDIRforFilename(filename);
    currLambda = lambdaDelta*i;
    for j = 1:numFrames
        readNoise = normrnd(0,sigma,xSize,ySize);
        lightFrame = poissrnd(currLambda,xSize,ySize);
        capture = readNoise + lightFrame;
        capture = capture*gain + offset;
        capture = uint16(capture);
        currName = [filename '_t' num2str(j) '.tif'];
        imwrite(capture,currName,'tif', 'Compression', 'none');
    end
end
end

