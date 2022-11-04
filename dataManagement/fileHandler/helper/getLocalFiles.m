function [fileList] = getLocalFiles(dirName,varargin)
%GETLOCALFILES will looking to dirName and return all the files with ext
if isunix
    [status,cmdout] = unix(['find ' dirName ' -maxdepth 1 -type f']);
    if isempty(cmdout)
        fileList = [];
        return;
    end
    
    cmdout = textscan(cmdout,'%s','delimiter','\n');
    cmdout = cmdout{1};
    fileList = cmdout;
    % match dir at beging of line, this filters non folder statements
    if ~isempty(varargin)
        regexpFilterkey = varargin{1};
        fileList = keepCertainStringsUnion(fileList,regexpFilterkey);
    end
    
else
    dirData = dir(dirName);      %Get the data for the current directory
    dirIndex = [dirData.isdir];  % Find the index for directories
    fileList1 = {dirData(~dirIndex).name}';  % Get a list of the files
    if ~isempty(varargin{1})
        fileList = keepCertainStringsUnion(fileList1,varargin{1});
    else
        
    end
    
    if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),...  % Prepend path to files
            fileList,'UniformOutput',false);
    end
end
end

