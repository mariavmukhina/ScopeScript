function pathToFile = returnFilePath(filePath)
%RETURNFILEPATH takes filePath and returns the path to the folder where the
%file resides in

if iscell(filePath)
    pathToFile = cell(numel(filePath),1);
    for i = 1:numel(filePath)
         [pathToFileCurrent,~,~] = fileparts(filePath{i});
        pathToFile{i} = [pathToFileCurrent filesep];
    end
else
    [pathToFile,~,~] = fileparts(filePath);
end



end

