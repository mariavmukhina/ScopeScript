function [] = runCalibration(correct,varargin)
%RUNCALIBRATION executes mean variance and dark frame measurement

global mmc;

stopStreaming();

if ~correct
    sensorDefectCorrectOFF();
else
    sensorDefectCorrectON(); 
end

if isempty(varargin)
fcScope = scopeParams;
else
   fcScope = varargin{1}; 
end
pauseTime = fcScope.pauseTime;

setExposure(fcScope.cameraExposureLivePL);
disp('waiting for specified minutes so door is closed and room is dark');
disp('BEFORE STARTING you  need to calibrate the maximum light intensity and liveBF to make sure it does not saturate ---> run testSaturation');
disp('ALSO, the gains are bimodal if the intensities go to high!!, use low intensities');
disp(['exposure is set to ' num2str(mmc.getExposure)]);
pause(pauseTime);
fileLocationDark = runDarkFrameCalibration();
fileLocationMeanVar = runPhotonTransferCalibration();
calibrateSensorGain(fileLocationMeanVar,fileLocationDark);

end

