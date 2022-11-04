function [] = writeStream(numFrames,filename,nextIndex)
%WRITESTREAM streams and writes by blocks of numFrames
%
% fchang@fas.harvard.edu

global mmc;
width = mmc.getImageWidth;
height = mmc.getImageHeight;
j = 0;
imageCount = 1;
mmc.startSequenceAcquisition(numFrames, 0, false);
while(imageCount > 0 || j < numFrames &&  double(mmc.isBufferOverflowed()) == 0)
    imageCount = mmc.getRemainingImageCount();
    if (imageCount > 0)
        j = j+1;
        currName = [filename '_t' num2str(nextIndex+j) '.tif'];
        imwrite(reshape(typecast(mmc.popNextImage(),'uint16'),width,height), currName ,'tif', 'Compression', 'none');
    end
end
if double(mmc.isBufferOverflowed()) == 0
    
else
   warning('buffer overflowed'); 
end
end

