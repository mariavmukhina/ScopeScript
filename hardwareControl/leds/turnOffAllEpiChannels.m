function [] = turnOffAllEpiChannels()
global mmc;

mmc.setProperty('pE4000','Global State',0);
mmc.setProperty('pE4000','Lock Pod',0)
end