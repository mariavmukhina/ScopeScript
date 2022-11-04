function [] = setZstartEndDAC(zIndexStart,zIndexEnd)
%SETZSTARTENDDAC given a zstack program inside the hardware controller,
%this will set the beginning and ending indices that the controller loops over.
%This is useful when you want to execute only a subset of the instructions
%without re-writing the controller program
%e.g.: take a z stack with smaller than maximum (256) number of slices
% fchang@fas.harvard.edu

global mmc;
mmc.setSerialPortCommand(scopeParams.fcPiezoCircuitCOMPort,['s' num2str(zIndexStart) ',' num2str(zIndexEnd)],'');
end

