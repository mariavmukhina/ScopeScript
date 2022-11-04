function fileList = keepCertainStringsUnion(fileList,keepFile)
%REMOVECERTAINFILES takes fileList and returns a new fileList with
%removeFile removed from the list.
% keepFile can be a cell array of regexp patterns that this function will
% return the union of them


if isempty(fileList)
    fileList = [];
    return;
end

if ~iscell(keepFile)
    dsCheck = regexp(fileList,keepFile);
    dsCheck = cellfun('isempty',dsCheck);
    fileList(dsCheck) = [];  
else
    dsCheck = zeros(length(fileList),1);
    for i = 1:numel(keepFile)
        currKeeper = keepFile{i};
        dsChecktemp = regexp(fileList,currKeeper);
        dsCheck = dsCheck + ~cellfun('isempty',dsChecktemp); 
    end
    fileList(dsCheck==0) = [];
end

fileList = fileList(~cellfun('isempty',fileList));



end

