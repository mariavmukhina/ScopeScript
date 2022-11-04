function [] = initHamamatsu()

global mmc;
global ti2;

disp('initializing Hamamatsu C13440');
ti2.LightPath.Value = 4;
mmc.setCameraDevice('C13440');
mmc.setProperty('C13440','OUTPUT TRIGGER POLARITY[0]','POSITIVE');
mmc.setProperty('C13440','OUTPUT TRIGGER POLARITY[1]','POSITIVE');
mmc.setProperty('C13440','OUTPUT TRIGGER POLARITY[2]','POSITIVE');
mmc.setProperty('C13440','OUTPUT TRIGGER KIND[0]','EXPOSURE');
mmc.setProperty('C13440','OUTPUT TRIGGER KIND[1]','EXPOSURE');
mmc.setProperty('C13440','OUTPUT TRIGGER KIND[2]','EXPOSURE');
mmc.setProperty('C13440','ScanMode',2);
sensorDefectCorrectOFF();
try
mmc.setProperty('C13440','Sensor Cooler','ON');
disp('water cooling: ON');
disp('!!!!TURN ON WATER COOLER!!!!!');

catch
    disp('air cooling');
    disp('Scan speed is set to fast mode');
end
end