function filePath = genDarkFrames()
%GENDARKFRAMES Summary of this function goes here
%   Detailed explanation goes here

sigma = 1.6;
offset = 100;
xSize = 256;
ySize = 256;
gain = 2;

fcScope = scopeParams;
numFrames = fcScope.numDarkFrames;
darkPath = fcScope.darkFramesPath;
sigma = fcScope.syn_sigma;
offset = fcScope.syn_offset;
xSize = fcScope.syn_xSize;
ySize =fcScope.syn_ySize;
gain = fcScope.syn_gain;
filePath = [returnPath(fcScope) filesep darkPath];
filename = [filePath 'darkFrame'];
makeDIRforFilename(filename);
for j = 1:numFrames
    darkFrame = uint16(round(gain*normrnd(0,sigma,xSize,ySize))+offset);
    currName = [filename '_t' num2str(j) '.tif'];
    imwrite(darkFrame,currName,'tif', 'Compression', 'none');
end
end

