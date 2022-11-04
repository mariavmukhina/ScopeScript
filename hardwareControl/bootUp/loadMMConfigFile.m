function [] = loadMMConfigFile()
%LOADCONFIGFILE imports mmcorej.* and creates cmmcore object and loads
%configuration file

global mmc;
fcScope = scopeParams;
import mmcorej.*;
mmc = CMMCore;
mmc.enableStderrLog(false);
mmc.enableDebugLog(false);
disp('loading other hardware configuration ...');
mmc.loadSystemConfiguration(fcScope.configPath);



