function filePath = testSaturation()
%TESTSATURATION will run live BF acquisition with maximum settings to be used by runPhotonTransferCalibration() later on to ensure that camera sensor is not saturated

fcScope = scopeParams();
exposure = max(fcScope.exposureTitration)
brightFieldLEDChannel = fcScope.brightFieldLEDChannel;
fluorescenceChannel   = fcScope.fluorescenceChannel;
energy = fcScope.energyLevel;

% setup microscope
ttlPiezo();
fcScope.cameraPath();
setExposure(exposure);
stopStreaming();
setFilterCube(fluorescenceChannel);
closeTurretShutter();

% initialize brightfield LED
setBrightFieldTTL(brightFieldLEDChannel,energy);
oldROI = getROI();
clearROI();
doLive(oldROI);

turnOffAllLEDs();
unlockBrightFieldLED();
end

