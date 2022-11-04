function curatedPath = removeDoubleFileSep(myPath)
%REMOVEDOUBLEFILESEP removes double file separators in the string myPath

curatedPath = regexprep(myPath,'/{2,}','/');
curatedPath = regexprep(curatedPath,'\\{2,}','\');


end

