function [] = loadMMJarFiles()
%LOADJARFILES looks inside jarFolder and loads all the jars found inside

fcScope = scopeParams;
jarPath = 'plugins\Micro-Manager';
jarFolder = [fcScope.micromanagerPath jarPath];
jarFiles = getLocalFiles(jarFolder,'jar');
% load micromanager jars
for i = 1:numel(jarFiles)
    javaaddpath(jarFiles{i});
end
javaaddpath([fcScope.micromanagerPath 'ij.jar']);
% add uManager folder so dlls can be found
addpath(fcScope.micromanagerPath);

end

