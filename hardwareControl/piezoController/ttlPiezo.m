function [] = ttlPiezo()
%TTLPIEZO holds stage position constant and switches all the LEDs to TTL-trigger ready state
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'t','');

end

