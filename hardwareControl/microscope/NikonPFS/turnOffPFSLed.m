function [] = turnOffPFSLed()
%TUTNONPFS if PFS is off, then PFS LED is turned on and PFS dicroic mirror
%is put into lightpath
global ti2;
ti2.iPFS_DM = 1;
ti2.iPFS_SWITCH = 0;
disp('PFS LED is switched off');
end
