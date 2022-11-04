function stack = importStack(filename)
%IMPORTSTACK imports either tif or fits stack.

[~,~,ext] = fileparts(filename);

switch ext
    case {'.fit','.fits'}
        stack = importFits(filename);
    case {'.tif','.TIF'}
         stack = importSingleTiffStack(filename);
    otherwise
        error('do not recognize file extension');
end

stack = double(stack);

end

