function [] = PL()
%PL sets Andor camera to EMCCD mode with electron gain 100, typically
%suitable for photoluminescence images acquisition

global mmc;
if mmc.getCameraDevice() == 'Andor'
    mmc.setProperty('Andor','FrameTransfer','On');
    mmc.setProperty('Andor','EMSwitch','On');
    mmc.setProperty('Andor','Gain','100');
    mmc.setProperty('Andor','ReadoutMode','30.000 MHz');
    mmc.setProperty('Andor','VerticalClockVoltage','+4');
    mmc.setProperty('Andor','VerticalSpeed','4.33');
    disp('PL configuration selected: readout 30 MHz, vert shift 4.33, EM 100');
end
end

