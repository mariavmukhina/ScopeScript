function [] = writeStreamParsed(fileNames,nFrames,wavelengths,N,metaDataList)
%WRITESTREAMPARSED for continuous z stack acquisition, the streaming frames
%need to be organized back into stacks, with overlaps at the top and bottom
%of the stack.  
% writeStreamParsed({'location'},100,{'blueTTL','redTTL'},10,metaDataList);
% this will write to location, 100 stacks, two wavelengths, with z slices
% of 10.  blueTTL will have metaDataList{1} and redTTL will get
% metaDataList{2}
%

% image parameters
width = getWidthOfROI();
height = getHeightOfROI();
% allocate memory for the stacks
if iscell(wavelengths)
   numWaves = numel(wavelengths); 
else
   numWaves = 1;
end
stackHolder = zeros(width,height,N,numWaves,'uint16');
% acquire Nframes of N*numel(wavelengths) minus overlap
streamN = nFrames*N*numWaves - numWaves*(nFrames - 1);
% a trianglewave indexes the stack in a continous pattern given a stream index.  
triangleWaveFunc = @(x,height) abs(-abs(mod(x,2*(N-1))-height)+height)+1;
% if several wavelengths are interleaved in the stream, then only increment
% index when wavelengths are finished per slice
effectiveIndex = 0;
imageCount = 0;
% generate meta data for each TTL trigger

global mmc;
clearBuffer();
mmc.startSequenceAcquisition(streamN, 0, false);
while(imageCount < streamN && double(mmc.isBufferOverflowed()) == 0)
    remainingImageCount = mmc.getRemainingImageCount();
    if (remainingImageCount > 0)
        zIndex = triangleWaveFunc(effectiveIndex,N-1);
        waveIndex = mod(imageCount,numWaves)+1;
        incrementIndex = mod(imageCount,numWaves) == (numWaves-1);
        currFrame = mmc.popNextImage();
        currFrame = reshape(typecast(currFrame,'uint16'),width,height);
%         fprintf('streami:%u zIndex:%u waveIndex:%u eIndex:%u\n',imageCount,zIndex,waveIndex,effectiveIndex);
        % save in appropriate stackHolder slice
        stackHolder(:,:,zIndex,waveIndex) = currFrame;
        % save z stack as tif at beg and end of stack
        if (imageCount+1 >= N) && ((zIndex == N) || (zIndex == 1))
             exportSingleTifStack([fileNames{waveIndex} '_dt' num2str((effectiveIndex)/(N-1))],stackHolder(:,:,:,waveIndex),metaDataList{waveIndex}{(zIndex==1)+1});
        end
        imageCount = imageCount+1;
        effectiveIndex = effectiveIndex + incrementIndex;
    end
end

if double(mmc.isBufferOverflowed()) == 1
    warning('buffer overflowed');
end
end

