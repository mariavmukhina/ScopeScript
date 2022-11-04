function [parent] = getParentDirecotory(filePath)
%GETPARENTDIRECOTORY returns the parent directory
%
% /fred/chang/boy.file
% returns /fred/

splitParent = strsplit(filePath,{'/','\'});
splitParent = removeEmptyCells(splitParent);
splitParent = splitParent(1:end-1);
parent = insertAStringBetweenCells(filesep,splitParent);
end

