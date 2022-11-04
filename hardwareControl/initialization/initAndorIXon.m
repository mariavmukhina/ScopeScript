function [] = initAndorIXon()
global mmc;
global ti2;
disp('initializing Andor iXon');
ti2.LightPath.Value = 2;
mmc.setCameraDevice('Andor');
mmc.setProperty('Andor','BaselineClamp','Enabled');
mmc.setProperty('Andor','CCDTemperatureSetPoint','-75');
disp('Sensor temperature is set to -75C');
disp('!!!For temperature stability turn on water cooling!!!!');
mmc.setProperty('Andor','EMSwitch','Off');
mmc.setProperty('Andor','FanMode','Full');
mmc.setProperty('Andor','FrameTransfer','Off');
mmc.setProperty('Andor','Output_Amplifier','Electron Multiplying');
mmc.setProperty('Andor','Pre-Amp-Gain','Gain 2');
mmc.setProperty('Andor','ReadMode','Image');
mmc.setProperty('Andor','Region of Interest','Full Image');
mmc.setProperty('Andor','Shutter (External)','Open');
mmc.setProperty('Andor','Shutter (Internal)','Open');
mmc.setProperty('Andor','Shutter Closing Time','0');
mmc.setProperty('Andor','Shutter Opening Time','0');
mmc.setProperty('Andor','SpuriousNoiseFilter','None');
mmc.setProperty('Andor','Trigger','Software');

%set camera to CCD mode, EM = 0
BF();  

end