function [] = calibrateBySyntheticData()
%GENSYNTHETICCALDATA will generate synthetic data then calibrate.  This
%function is used to test the routines that calibrate the sensor
display('testing sensor calibration by generating synthetic data and calibrating that');
fileLocationDark = genDarkFrames();
display('dark frames done');
fileLocationMeanVar = genPhotonTransferCalibration();
display('mean variance done');
calibrateSensorGain(fileLocationMeanVar,fileLocationDark);
display('done');
end

