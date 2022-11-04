function [] = setBrightFieldManual(color,intensity)
% color can be 3000K,4300K,6500K,Blue,Green,Manual,Red,
global mmc;
presetColors                  = {'3000K','4300K','6500K','Red','Green','Blue'};  % from manual
colorNumbers                  = {'01','02','03','04','05','06'};
colorMap                      = containers.Map(presetColors,colorNumbers);
intensityHEX                  = dec2hex(intensity);
checkSum                      = dec2hex(2^8-(81+hex2dec(colorMap(color))+intensity));
playPresetColor               = {'A9','04','4D',colorMap(color),intensityHEX,checkSum,'5C'};
setManualControllerLockoutON  = {'A9','03','53','01','A9','5C'};
setUSBControl                 = {'A9','03','27','03','D3','5C'};
setManualControllerLockoutOFF = {'A9','03','53','00','AA','5C'};

fcScope = scopeParams();
comPortScopeLED = fcScope.mmScopeLEDCOMPort;

mmc.writeToSerialPort(comPortScopeLED,charVector(setManualControllerLockoutON));
pause(1/1000);
mmc.writeToSerialPort(comPortScopeLED,charVector(setUSBControl));
pause(1/1000);
mmc.writeToSerialPort(comPortScopeLED,charVector(playPresetColor));
pause(1/1000);
mmc.writeToSerialPort(comPortScopeLED,charVector(setManualControllerLockoutOFF));
end

