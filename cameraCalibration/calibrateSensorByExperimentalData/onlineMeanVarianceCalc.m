function [meanSig,meanSig2,sigVariance] = onlineMeanVarianceCalc(frameList)
%ONLINEMEANVARIANCECALC given a frameList, this calculates a stable
%statistic per pixel across the entire frameList

genericMeta = getMetaDataOfTifs(frameList{1});
width = genericMeta.width;
height = genericMeta.height;
meanSig = zeros(width,height);
meanSig2 = zeros(width,height);
N = numel(frameList);
for i = 1:N
    currFrame = double(importStack(frameList{i}));
    delta = currFrame - meanSig;
    meanSig = meanSig + delta / i;
    meanSig2 =  meanSig2 + delta.*(currFrame - meanSig);
end
sigVariance = meanSig2 ./ (N-1);
 
end

