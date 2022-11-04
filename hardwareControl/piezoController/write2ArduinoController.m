function [] = write2ArduinoController(serialCmd)
%WRITE2ARDUINOCONTROLLER writes to the serial port that is connected to the
%arduino hardware controller
%
% fchang@fas.harvard.edu
global mmc;
mmc.setSerialPortCommand(scopeParams.fcPiezoCircuitCOMPort,serialCmd,'');


end

