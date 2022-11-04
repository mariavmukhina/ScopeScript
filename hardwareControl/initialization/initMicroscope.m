function [] = initMicroscope()
global mmc;
global showROI;
parpool();

disp('!!! all hardware shoould be on at the moment of initialization for it to run successfully !!!');
disp('you can turn off any unused hardware after initialization');

turnOffAllLEDs();

%close epifluor excitation shutter
closeTurretShutter();
mmc.setAutoShutter(0);

%set accuracy of Nikon XY stage
fastStage();

%for multi-camera setup, choose between two cameras
%regardless of selection, both cameras should be on at the moment of script initialization
camera = str2double(cameraSelection());
if camera == 1
    initHamamatsu();
    %user-defined ROI may be selected to be shown as a white rectangle in all acquired images
    showROI = [1, 1, 2048, 2048];
    %showROI = [512, 512, 1024, 1024];
elseif camera == 2
    initAndorIXon();
    showROI = [1, 1, 1024, 1024];
end

%set brightfield light source (ScopeLED) to manual regime, in which color and intesity can be changed by LED controls
setBrightFieldManual('4300K',1);

%print all the filtercubes in Nikon turret
printAvailableFilterCubes();
%holdPiezoBF keeps stage TTL constant, BF TTL constant, PL is TTL triggered
holdPiezoBF();
% start nanomanipulator for mechanical stimulation of the sample simultaneously with image acquisition
initiateNanocube();
end