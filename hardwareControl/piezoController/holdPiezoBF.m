function [] = holdPiezoBF()
%holdPiezoBF keeps stage constant, BF constant, PL is TTL triggered
disp('set piezo to holding...');
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'b','');
end


