function [FinalImage,myMeta] = importSingleTiffStack(file)
%importSingleTiffStack reads file location and imports tiff as uint16
%matrix
% 3dStack = importSingleTiffStack('./fileLoc.tif');
% [3dStack, ImageDescription] = importSingleTiffStack('./fileLoc.tif');
%
% fchang@fas.harvard.edu

FileTif=file;
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);

% if user reguests myMeta, check if it exists and parse the meta file that
% is comma delimited
if isfield(InfoImage(1),'ImageDescription');
    myMeta = InfoImage(1).ImageDescription;
    if ~isempty(myMeta) && nargout == 2
        myMeta = textscan(myMeta,'%s','Delimiter',',');
        myMeta = myMeta{1};
        myMeta = cell2struct(myMeta(2:2:end),myMeta(1:2:end),1);
    end
end

FinalImage=zeros(nImage,mImage,NumberImages,'uint16');
for i=1:NumberImages
    FinalImage(:,:,i)=imread(FileTif,'Index',i,'Info',InfoImage);
end
end

