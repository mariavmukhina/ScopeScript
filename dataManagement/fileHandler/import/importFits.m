function [fitsData] = importFits(filename)
%IMPORTFITS Summary of this function goes here
%   Detailed explanation goes here

% import matlab.io.*
% fptr = fits.openFile(filename);
% fitsData = fits.readImg(fptr);
% fits.closeFile(fptr);

filename = regexprep(filename,'^~',getHomeDir);
% append fits extension
filename = updateFileExtension(filename,'fits');
checkParen = regexp(filename,'[(|)]','ONCE');
if ~isempty(checkParen)
    display('!!! REMOVING PARENTHESIS IN FILEPATH!!!!!');
end
filename = regexprep(filename,'[(|)]','-');

fitsData = flipud(fits_read(filename));

end

