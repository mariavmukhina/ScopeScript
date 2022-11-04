function [] = AndorPhCount()
%AndorPhCount sets Andor camera to photon counting mode
%choice between AndorPhCount and PL can be added in executeFunctionsInFcScopeList() line 31 

global mmc;
if mmc.getCameraDevice() == 'Andor'
    mmc.setProperty('Andor','FrameTransfer','Off');
    mmc.setProperty('Andor','EMSwitch','On');
    mmc.setProperty('Andor','Gain','1000');
    mmc.setProperty('Andor','ReadoutMode','10.000 MHz');
    mmc.setProperty('Andor','VerticalClockVoltage','Normal');
    mmc.setProperty('Andor','VerticalSpeed','1.13');
    mmc.setProperty('Andor','Region of Interest','1. 512 x 512 (centered)');
    mmc.setProperty('Andor','CCDTemperatureSetPoint','-95');
    disp('Waiting for sensor to cool down to -93C');
    sensorTemp = mmc.getProperty('Andor','CCDTemperature');
    while strcmp(sensorTemp,'-95')~=1 && strcmp(sensorTemp,'-94')~=1 && strcmp(sensorTemp,'-93')~=1
        sensorTemp = mmc.getProperty('Andor','CCDTemperature');
        disp(['Sensor temperature is ' char(sensorTemp)]);
        pause(30);
    end
    disp('Sensor temperature is set to -93C');
    disp('Photon Counting configuration is selected: readout 10 MHz, vert shift 1.13, EM 1000');
end
end