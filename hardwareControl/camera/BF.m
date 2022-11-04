function [] = BF()
%BF switches Andor camera to CCD regime (no electron gain) suitable for
%brightfield image acquisition
global mmc;
if mmc.getCameraDevice() == 'Andor'
    mmc.setProperty('Andor','FrameTransfer','On');
    mmc.setProperty('Andor','CCDTemperatureSetPoint','-75');
    mmc.setProperty('Andor','ReadoutMode','30.000 MHz');

    mmc.setProperty('Andor','VerticalClockVoltage','+4');
    mmc.setProperty('Andor','VerticalSpeed','4.33');
    mmc.setProperty('Andor','EMSwitch','Off')
    disp('BF configuration selected: readout 30 MHz, vert shift 4.33, EM 0');
end
end