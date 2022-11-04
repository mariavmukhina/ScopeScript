function [varargout] = printAvailableFilterCubes()
%PRINTAVAILABLEFILTERCUBES prints available filter cube

global ti2;
[lower] = ti2.Turret1Pos.Lower;
[higher] = ti2.Turret1Pos.Higher;
ti2Turret = ti2.Turret1Pos;
filterCubes = cell(higher,1);
for i = lower : higher
    filterCubes{i} = strcat(num2str(i),'-',get(ti2Turret,'ShortName',i));
end

if nargout ==0
   display(['fluorescent channels: ' insertAStringBetweenCells(',',filterCubes)])
elseif nargout ==1
    varargout{1} = filterCubes;
else
    
end

end

