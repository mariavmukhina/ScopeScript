function [daListOrganized] = getOrderedListFromMatch(fileList,dx,mode)
%GETORDEREDLISTFROMMATCH returns an ordered list with dx the one changing
%in orderDirection.  e.g. dx = '_e[0-9]+' then the fileList will be ordered by
%_e1 _e2 _e3 ... if the orderDirection is 'ascending'.
% daList is just fileList ordered
% daListOrganized returns list of the unique names first then underneat
% that returns the ordered list... this format helps in organizing the data
% mode is 'decend' or 'ascend'

if isempty(fileList)
   daListOrganized = [];
   return;
end

% find stuff that matches dx
fileList = keepCertainStringsUnion(fileList,['.*' dx]);
if isempty(fileList)
   daListOrganized = [];
   return;
end
% get unique names
[uniqueNames,first_uniqueName,second_uniqueName] = getUniqueNamesFromList(fileList,dx);
% generate ordered dataset given uniqueNames
daListOrganized = cell(numel(uniqueNames),1);
for i = 1:numel(uniqueNames)
    daListOrganized{i}.name = uniqueNames{i};
    % get matching names
    % escape regexp special characters
    firstNames = regexprep(first_uniqueName{i},'[\[\$\^\.\\\*\+\[\]\(\)\{\}\?\|\]]', '\\$0');
    secondNames = regexprep(second_uniqueName{i},'[\[\$\^\.\\\*\+\[\]\(\)\{\}\?\|\]]', '\\$0');
    subMatch = keepCertainStringsUnion(fileList,[firstNames dx secondNames]);
    [daListOrganized{i}.subMatch, daListOrganized{i}.dxTrack] = getOrderedList(subMatch,dx,mode);
    daListOrganized{i}.varying = dx;
end

