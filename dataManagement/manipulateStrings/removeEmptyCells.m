function [cellArray] = removeEmptyCells(cellArray)
%REMOVEEMPTYCELLS finds empty cells and removes them

emptyOnes = cellfun('isempty',cellArray);
cellArray(emptyOnes) = [];

end

