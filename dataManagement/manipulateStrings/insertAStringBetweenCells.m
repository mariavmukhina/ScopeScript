function [insertedString] = insertAStringBetweenCells(myString,cellsOfStrings)
%INSERTASTRINGBETWEENCELLS will insert myString between cellsOfStrings
% if cellsOfString has a numeric in it, it will convert it to a string

if ischar(cellsOfStrings)
    insertedString = cellsOfStrings;
    return;
end

for i = 1:numel(cellsOfStrings)
    if ~isstr(cellsOfStrings{i})
        if isnumeric(cellsOfStrings{i})
            cellsOfStrings{i} = num2str(cellsOfStrings{i});
        else
            error('not a string or numeric in an element of the cellsOfStrings');
        end
    end
end

if strcmp(myString,'\')
    myString = '\\';
end
insertedString = sprintf(['%s' myString],cellsOfStrings{:});
insertedString = strtrim(insertedString);
% remove tailing insertion
insertedString = regexprep(insertedString,[myString '$'],'');
end

