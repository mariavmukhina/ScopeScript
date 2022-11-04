function [] = resetZStackToZero()
%RESETZSTACK Summary of this function goes here
%   Detailed explanation goes here
global mmc;
comPort = scopeParams.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'a','');
if waitForArduinoConfirmation() == 1
   disp('----resetZStackToZero()--------------');
   disp('zstack reset to zero...'); 
end


end

