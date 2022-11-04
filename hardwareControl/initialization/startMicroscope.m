%STARTMICROSCOPE startups the microscope and initializes other hardware

% load Nikon Ti2 configuration
loadNikonTI2();
% loads the java library
loadMMJarFiles();
% loads the uManager config file and returns mmc object
loadMMConfigFile();

global ti2;
global mmc;
%multiple xy stage positions
global stageCoordinates;
global masterFileMaker;
%user-defined ROI to be shown as a white rectange in all saved images
%default is full ROI
global showROI;
%nanoCube nanomanipulator
global E727;
%recoding of Z positions of the stage
global liveStageONOFF;
liveStageONOFF = 0;

%prepare to save the data
masterFileMaker = masterFileGenerator();

% set image buffer size
mmc.setCircularBufferMemoryFootprint(scopeParams.bufferSize);
mmc.initializeCircularBuffer();

initMicroscope();

