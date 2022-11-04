function [uniqueNames,first_uniqueName,second_uniqueName] = getUniqueNamesFromList(fileList,dx)
%GETUNIQUENAMESFROMLIST get unique names given dx match then returns the
%split name around dx

% find nonempty match
fileList =  keepCertainStringsUnion(fileList,['.*' dx]);
% find unique names
splitList = regexp(fileList,dx,'split');
firstPart = cellfun(@(x) x{1},splitList,'UniformOutput',false);
secondPart = cellfun(@(x) x{2},splitList,'UniformOutput',false);
% i will append firstPart and secondPart with a '!!' indicating the
% appending location and find the unique names for this set.  
uniqueNames = cellfun(@(x,y) [x '!!' y],firstPart,secondPart,'UniformOutput',false);
uniqueNames = unique(uniqueNames);
% then parse '!!'
uniqueNames = regexp(uniqueNames,'!!','split');
first_uniqueName = cellfun(@(x) x{1},uniqueNames,'UniformOutput',false);
second_uniqueName = cellfun(@(x) x{2},uniqueNames,'UniformOutput',false);
% combine first and second name
uniqueNames = cellfun(@(x,y) [x y],first_uniqueName,second_uniqueName,'UniformOutput',false);
end

