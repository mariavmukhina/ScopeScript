function [] = constantPiezo()
%CONSTANTPIEZO holds stage, brightfield and fluorescent TTLs are constant and high (LEDs on)
global mmc;
fcScope = scopeParams();
comPort = fcScope.fcPiezoCircuitCOMPort;

mmc.setSerialPortCommand(comPort,'c','');

end

