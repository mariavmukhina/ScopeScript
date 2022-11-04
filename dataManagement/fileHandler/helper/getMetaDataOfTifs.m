function [genericMeta,myMeta] = getMetaDataOfTifs(file)
%return the meta data associated with the tif 'file'

FileTif=file;
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);

genericMeta.width = mImage;
genericMeta.height = nImage;
genericMeta.NumberImages = NumberImages;
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

end

