function [] = holdPiezoPL()
%holdPiezoEpi holds stage position, PL triggers are constant, BF is ttl triggered
disp('set piezo to holding...');
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'f','');
end
