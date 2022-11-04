function [] = makeDIRforFilename(filename)
%MAKEDIRFORFILENAME will generate directory necessary for filename

[~,~,~] = mkdir(returnFilePath(filename));


end

