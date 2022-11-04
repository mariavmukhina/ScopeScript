function [] = unlockBrightFieldLED()

global mmc;

setManualControllerLockoutOFF = {'A9','03','53','00','AA','5C'};

fcScope = scopeParams();
comPortScopeLED = fcScope.mmScopeLEDCOMPort;

mmc.writeToSerialPort(comPortScopeLED,charVector(setManualControllerLockoutOFF));

end