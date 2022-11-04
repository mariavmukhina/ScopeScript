function [ ] = initiateNanocube()
%initiateNanocube 
% - load the PI MATLAB Driver GCS2
% - connect to the E727
% - initialize the E727
% - set the stage connected to E727
% - auto zero all available axes 
%- switch on servo (closed loop)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global E727;
disp('connecting to NanoCube...');

%% Load PI MATLAB Driver GCS2

if (~exist('C:\Users\Public\PI\PI_MATLAB_Driver_GCS2','dir'))
    error('The PI MATLAB Driver GCS2 was not found on your system. Probably it is not installed. Please run PI_MATLAB_Driver_GCS2_Setup.exe to install the driver.');
else
    addpath('C:\Users\Public\PI\PI_MATLAB_Driver_GCS2');
end

if(~exist('Controller','var'))
    Controller = PI_GCS_Controller();
end;
if(~isa(Controller,'PI_GCS_Controller'))
    Controller = PI_GCS_Controller();
end


%% Parameters

% Set the correct stage type. A WRONG STAGE TYPE CAN DAMAGE YOUR STAGE!
stageType = 'P-611.3S"';

% Connection settings
controllerSerialNumber = '0118080597';    % Use "devicesUsb = Controller.EnumerateUSB('')" to get all PI controller connected to you PC.
                                                                                    % Or look at the label of the case of your controller


%% Start connection

E727 = Controller.ConnectUSB(controllerSerialNumber);

% query controller identification
E727.qIDN();

% initialize controller
E727 = E727.InitializeController();


%% Configuration and referencing

% query controller axes
availableaxes = E727.qSAI_ALL;
if(isempty(availableaxes))
	error('No axes available');
end

AxisCellArray = regexp(availableaxes,'\s\n','split');
axisname1 = AxisCellArray{1,1}{1}; % to query single axis
axisname2 = AxisCellArray{1,2}{1};
axisname3 = AxisCellArray{1,3}{1};                                                            
                                                            
% Auto Zero all available axes                              
E727.ATZ(availableaxes);    
                                                            
% wait until all axes are set to zero: all([1 1 1]) >> 1  
autozeroStatus = E727.qATZ();
autozeroStatus = autozeroStatus(1:3,1);
while(0 == all(autozeroStatus)) 
    pause(0.1);
    autozeroStatus = E727.qATZ();
    autozeroStatus = autozeroStatus(1:3,1);
end

% Svitch on servo
E727.SVO(axisname1, 1);
E727.SVO(axisname2, 1);
E727.SVO(axisname3, 1);

%move to the middle of the axes range
pMax = E727.qTMX('3');
E727.MOV('3',pMax);
E727.MOV('2',pMax/2);
E727.MOV('1',pMax/2);
end

