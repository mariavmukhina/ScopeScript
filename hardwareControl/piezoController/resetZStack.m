function [] = resetZStack()
%RESETZSTACK Summary of this function goes here
%   Detailed explanation goes here
global mmc;
comPort = scopeParams.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'r','');
if waitForArduinoConfirmation()
   disp('----resetZStack()--------------');
   disp('zstack reset to ready position...'); 
end


end

