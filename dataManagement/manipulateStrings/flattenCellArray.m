function cellarray = flattenCellArray(cellarray)
%FLATTENCELLARRAY will flatten a complicated cell array
%
% fchang@fas.harvard.edu

while iscell(cellarray)
    if size(cellarray,1) == 1 && ~iscell(cellarray{1})
       % flattened if the first dimension is 1
       break; 
    end
    cellarray=cellfun(@(x) x(:).',cellarray,'uni',false);
    cellarray=[cellarray{:}];
end


end

