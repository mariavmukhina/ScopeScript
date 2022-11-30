function [] = runCalibration(correct,varargin)
%RUNCALIBRATION executes mean variance and dark frame measurement using the parameters from scopeParams
% !!!! BEFORE STARTING you  need to calibrate the maximum light intensity by running testSaturation() to make sure it does not saturate

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
disp(['waiting for' num2str(pauseTime) ' sec so door is closed and room is dark']);
disp('!!!! BEFORE STARTING you  need to calibrate the maximum light intensity by running testSaturation() to make sure it does not saturate');
disp('ALSO, the gains are bimodal if the intensities go to high!!, use low intensities');
disp(['exposure is set to ' num2str(mmc.getExposure)]);
pause(pauseTime);
fileLocationDark = runDarkFrameCalibration();
fileLocationMeanVar = runPhotonTransferCalibration();
calibrateSensorGain(fileLocationMeanVar,fileLocationDark);

end

