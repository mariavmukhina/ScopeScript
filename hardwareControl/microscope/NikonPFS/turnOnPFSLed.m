function [] = turnOnPFSLed()
%TUTNONPFS if PFS LED is off, then PFS LED is turned on and PFS dicroic mirror
%is put into lightpath
global ti2;

if get(ti2,'iPFS_DM') == 1 | get(ti2,'iPFS_SWITCH') == 0
    ti2.iPFS_DM = 2;
    ti2.iPFS_SWITCH = 1;
    disp('PFS LED is switched on');
end

end
