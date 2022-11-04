function folderList = getLocalFolders(dirName,varargin)
%GETALLFOLDERS will recursively grab all the folders in dirName

if isunix
    [status,cmdout] = unix(['find ' dirName ' -type d  -maxdepth 1']);
    cmdout = textscan(cmdout,'%s','delimiter','\n');
    cmdout = cmdout{1};
    % match dir at beging of line, this filters non folder statements
    folderList =  keepCertainStringsUnion(cmdout,['^' dirName]);
    if ~isempty(varargin)
        regexpFilterkey = varargin{1};
        folderList = keepCertainStringsUnion(folderList,regexpFilterkey);
    end
else
    dirData = dir(dirName);
    dirIndex = [dirData.isdir];  % Find the index for directories
    folderList = {dirData(dirIndex).name}';  % Get a list of the files
    validIndex = ~ismember(folderList,{'.','..'});  % Find index of subdirectories
    folderList = folderList(validIndex);
    if ~isempty(varargin)
        regexpFilterkey = varargin{1};
        folderList =  keepCertainStringsUnion(folderList, regexpFilterkey);
    end
    if ~isempty(folderList)
        folderList = cellfun(@(x) fullfile(dirName,x),...  % Prepend path to files
            folderList,'UniformOutput',false);
    end%   that are not '.' or '..'
end

end