function [updateFilename] = updateFileExtension(filename,newExt)
%UPDATEFILEEXTENSION will update the file exchagne to newExt

[path,file,~] = fileparts(filename);
if isempty(path)
    updateFilename = [file '.' newExt];
else
   updateFilename = [path filesep file '.' newExt]; 
end


end

