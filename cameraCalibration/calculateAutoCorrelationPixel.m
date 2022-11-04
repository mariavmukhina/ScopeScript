function [intensities] = calculateAutoCorrelationPixel(fileLocationMeanVar)
%CALCULATEAUTOCORRELATIONPIXEL Summary of this function goes here
%   Detailed explanation goes here

N = 10000;
x = 200;
y = 200;
meanVarFolder = fileLocationMeanVar;
meanVars = getLocalFiles(meanVarFolder,'tif');
daListOrganized = getOrderedListFromMatch(meanVars,'_t[0-9]+','ascend');
nEnergies = numel(daListOrganized);
genericMeta = getMetaDataOfTifs(daListOrganized{1}.subMatch{1});
width = genericMeta.width;
height = genericMeta.height;
% initialize mean and variance frames for each energy
intensities = zeros(N,1);
% calculate online mean variance for each energy
for i = 1:N
    display(i);
    currFile = daListOrganized{10}.subMatch{i};
    currImage = importStack(currFile);
    intensities(i) = currImage(x,y);
end



