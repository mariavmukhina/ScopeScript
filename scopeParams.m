classdef scopeParams < matlab.mixin.SetGet & handle
    properties
        %% PATH TO EXPERIMENT FOLDER
        defaultSampleName       = 'test';
        defaultExpFolder        = 'test';

        %% EXPOSURE PARAMETERS FOR REAL TIME IMAGING WITH LIVEBF AND LIVEPL
        cameraExposureLivePL = 10;    % in ms
        cameraExposureLiveBF = 50;    % in ms      
        
        %% DEFINITION OF FUNCTIONS FOR EXECUTEFUNCTION() OR DOTIMELAPSE()
        % define experiments here; executeFunctions() uses setChannel,function and exposure; doTimeLapse() also uses timePoints
        
        % when executeFunctions() or doTimeLapse() are called, the script will look for function[i] = {functionName,argumentList} selected in executeOnly;
        % if selected more than one function, the functions will be run in the order defined in executeOnly

        executeOnly = [1]; 

        % then execute
        % i)   setChannel_i, if does not exist, do nothing
        % ii)  function_i
        % iii) at timePoints_i (seconds), if does not exist, do always
        
        % fcScope[1] takes zstacks at two channels defined by setupChannel(): 1 - in the PL channel "1-QDot" at 100% LED intensity, 2 - in the green BF channel at 50% intensity 
        setChannel1  = {{'1-QDot',100},{'GreenBrightField',50}};
        % parameters for zstacks are passed to takeA3DStack() to be sent to a custom TTL control board
        % "zstack[i]" (defined below) - number and size of steps of piezo stage
        % "ChATTL" - TTL trigger for CoolLED to be used with "1-QDot" channel
        % the full list of TTL triggers for CoolLED (PL) and ScopeLED (BF): 'AllFourTTL','ChDTTL','ChCTTL','ChBTTL','ChATTL','ChABTTL','ChBCTTL','ChABCTTL','BrightFieldTTL','AllOnTTL';
        function1    = {'takeA3DStack',{'zStack2','ChATTL','zStack2','BrightFieldTTL'},''};
        % if doTimeLapse() is called, 2 zstacks are taken at time points defined in timePoints[1]
        timePoints1  = 0:10:60; % start immediately, call function[1] every 10 sec for 60 sec total
        % both zstacks are taken with exposure[1]
        exposure1    = 100; %ms
        
        % fcScope[2] takes only 1 zstack in the PL channel "2-mTeal"
        setChannel2  = {{'2-mTeal',100}};
        function2    = {'takeA3DStack',{'zStack7','ChABTTL'},''};
        timePoints2  = 0:60*20:60*60*8;
        exposure2    = 10;
        
        setChannel3  = {{'3-GFP',100}};
        function3    = {'takeA3DStack',{'zStackZeroStep','ChBTTL'},''};
        timePoints3  = 0:60*2:60*60*60;
        exposure3    = 10;
        
        setChannel4  = {{'4-mCherry',100},{'GreenBrightField',20}};
        function4    = {'takeA3DStack',{'zStack1','ChCTTL','zStack1','BrightFieldTTL'},''};
        timePoints4  = 0:15:60*60*4;
        exposure4    = 50;
        
        % fcScope[5] takes 2D stack in the PL channel "5-YFP"
        setChannel5  = {{'5-YFP',100}};
        function5    = {'takeA3DStack',{'zStackZeroStep','ChBCTTL'},''};
        timePoints5  = 0:15:60*60*3;
        exposure5    = 10;
        
        setChannel6  = {{'6-CY5',100}};
        function6    = {'takeA3DStack',{'zStack4','ChDTTL'},''};
        timePoints6  = 0:10:60;
        exposure6    = 10;
        
        % fcScope[7] takes 3 zstacks: 2 in the PL channel "2-redGr" with a double band filter cube and 1 in the red BF channel
        %TTL triggers ChB and ChC alternate on frame by frame basis 
        setChannel7  = {{'2-redGr',{100,30}},{'RedBrightField',50}};
        function7    = {'takeA3DStack',{{'zStack1','zStack1'},{'ChBTTL','ChCTTL'},'zStack2','BrightFieldTTL'},''};
        timePoints7  = inf;
        exposure7    = 100;
        
        setChannel8  = {{'GreenBrightField',20}};
        function8    = {'takeA3DStack',{'zStack8','BrightFieldTTL'},''};
        timePoints8  = 0:10:60;
        exposure8    = 100;
        
        setChannel9  = {{'4-mCherry',50}};
        function9    = {'takeA3DStack',{'zStack4','ChCTTL'},''};
        timePoints9  = 0:10:60;
        exposure9    = 50;
        
        % fcScope[10] takes 2D stack at the PL channel "1-QDot" and simultaneously runs generateWave() to apply mechanical pressure wave to the sample
        % "6" defines number of recordings of Z position of the stage per frame
        setChannel10  = {{'1-QDot',0}};
        function10    = {'takeA3DStack',{'zStackZeroStep','ChATTL'},'generateWave',6};
        timePoints10  = 0:5:60*30;
        exposure10    = 200;
        
        %fcScope[11] takes 2D stack with 2 PL channels triggered
        %simultaneously for Optosplit
        setChannel11  = {{'6-TRF561-640',{6,2}}};
        function11    = {'takeA3DStack',{'zStackZeroStep1','AllFourTTL'},''};
        timePoints11  = 0:5:60*60;
        exposure11    = 50;
        
        %-zStack recipes---------------------------------------------------
        % z step is defined in DAC units, not nanometers
        % 1 DAC unit = 220 um[max stage range]/65536 ~= 3 nm
        zStack1_N   = 60; % number of slices
        zStack1_dz  = 75; % size of a piezo step; stage goes up
        zStack1_z0  = 0;  % starting plane
        
        zStack2_N   = 50;
        zStack2_dz  = -150; % stage goes down
        zStack2_z0  = 19*150;
        
        zStack3_N   = 15;
        zStack3_dz  = -300;
        zStack3_z0  = 4*300;
        
        zStack4_N   = 1;
        zStack4_dz  = 0;
        zStack4_z0  = 0;
        
        zStack5_N   = 11;
        zStack5_dz  = 400;
        zStack5_z0  = 0;
        
        zStack6_N   = 11;
        zStack6_dz  = -400;
        zStack6_z0  = 8*400;
        
        zStack8_N   = 180; 
        zStack8_dz  = -7;
        zStack8_z0  = 0;
        
        zStackZeroStep_N   = 50; %for 2D timeLapses
        zStackZeroStep_dz  = 0;
        zStackZeroStep_z0  = 0;
        
        zStackZeroStep1_N   = 5; %for 2D timeLapses
        zStackZeroStep1_dz  = 0;
        zStackZeroStep1_z0  = 0;

        %-zStack feed forward recipes--------------------------------------
        % these parameters define additional stage acceleration
        % acceleration obtained by sending triangle pulses defined by additional voltage ff1_deltaUp and ff1_deltaDown
        % for each z stack recipe, ff1_deltaUp and ff1_deltaDown have to be determined empirically
        % additional acceleration works only in open-loop mode of the z stage (faster but less accurate)
        % by default, the z stage is set up to the closed-loop mode to ensure stability, additional acceleration is not used
        % if parameter for chosen dz step is absent then stage will be moved with a standard rate 
        
        %ff1_dz          = 300;
        %ff1_deltaUp     = 1500;
        %ff1_delayUp     = 1;
        %ff1_deltaDown   = -500;
        %ff1_delayDown   = 1;
        
        %ff2_dz          = -300;
        %ff2_deltaUp     = -2850;
        %ff2_delayUp     = 1;
        %ff2_deltaDown   = 100;
        %ff2_delayDown   = 1;
        
        %ff3_dz          = -3000;
        %ff3_deltaUp     = -5000;
        %ff3_delayUp     = 20;
        %ff3_deltaDown   = 1000;
        %ff3_delayDown   = 1;
        
        %ff4_dz          = -1200;
        %ff4_deltaUp     = -5000;
        %ff4_delayUp     = 20;
        %ff4_deltaDown   = 1000;
        %ff4_delayDown   = 1;
        
        %ff5_dz          = 2700;
        %ff5_deltaUp     = 2930;
        %ff5_delayUp     = 1;
        %ff5_deltaDown   = -1000;
        %ff5_delayDown   = 1;
        
        %ff6_dz          = 400;
        %ff6_deltaUp     = 2230;
        %ff6_delayUp     = 1;
        %ff6_deltaDown   = -1000;
        %ff6_delayDown   = 1;
        
        %ff7_dz          = -400;
        %ff7_deltaUp     = -2850;
        %ff7_delayUp     = 1;
        %ff7_deltaDown   = 100;
        %ff7_delayDown   = 1;
        
        %ff8_dz          = -800;
        %ff8_deltaUp     = -3230;
        %ff8_delayUp     = 1;
        %ff8_deltaDown   = 100;
        %ff8_delayDown   = 1;
        
        %ff9_dz          = 800;
        %ff9_deltaUp     = 2230;
        %ff9_delayUp     = 1;
        %ff9_deltaDown   = -1000;
        %ff9_delayDown   = 1;
        
        %% -- OPTIONAL PARAMETERS ----------------------------------------------

        %% for mechanical stimulation of the sample synthronized with timelapse ascquisition

        %parameters of NanoCube pressure wave defined in generatewave()
        waveType         = 'square'; % square (pulses of constant pressure) Isquare(steps of increasing pressure), Dsquare (steps of increasing pressure); ramp assymtric triangular pulse
        restDuration     = 500;%msec 
        PpulseDuration   = 100;%msec 
        strainRate       = 0.125; %um/msec
        waveAmplitude    = 100; % in um for square wave, in MPa for ramp; 595 MPa is max value (calculated from deflection for 3.5 um needle pressing on fixed 170 um-thick glass substrate of 10 mm in diameter)
        %parameters for moveToInitialPosition()
        nanocubeX        = 50;
        nanocubeY        = 50;
        nanocubeZ        = 100;
        
        %% sCMOS camera calibration
        % runCalibration()
        pauseTime               = 60;
        
        % runDarkFrameCalibration()
        numDarkFrames           = 60000;
        darkFramesPath          = ['cameraCalibration' filesep 'darkFrames' filesep];
        streamInBlocksOf        = 100;

        % getMeanVarianceFrames()
        meanVariancePath        = ['cameraCalibration' filesep 'meanVariance' filesep];
        energyTitration         = 45:5:80;

        % testSaturation() and runPhotonTransferCalibration()
        exposureTitration       = 10:10:90;
        energyLevel    = 1;
        numEnergyTitrationFrames = 20000;
        fluorescenceChannel     = '5-mCherry';
        brightFieldLEDChannel   = 'Red';

        % calibrateBySyntheticData()
        syn_sigma               = 1.6;
        syn_offset              = 100;
        syn_xSize               = 256;
        syn_ySize               = 256;
        syn_gain                = 2;
        syn_fullWell            = 30000;

        %% misc

        % waitForPFS() - after turning ON Nikon PFS requires time to find focus
        waitForPFS_N            = 1000;
        waitForPFS_thresh       = 1;
        waitForPFS_timeout      = 5;

        % adjustGarbageFrames() - micromanager requests N frames, but there are garbage frames in front or back of stream.
        leadingGarbageFrames    = 0;
        laggingGarbageFrames    = 2;

        % setupChannel() - pause for vibration induced by moving filter turret
        pauseTimeFilterCube     = 1;
        pauseTimeShutters       = 1;

        % timelapse start delay in seconds
        startDelay              = 0;
        
        % timelapse stop function
        endFunction = @finishExperiment;
        

        %% -STATE VARIABLES--------------------------------------------------
        currentDate;            % this defines the exp folder
        pfsOffset;              % this defines the PFS offset if available
        stagePos;               % this defines the stage position to use
        currentDateTime;        % this is the curent date and time as datetime obj
        liveStageONOFF;         % this defines if z position of stage is tracked during z stack aquisition
    end
    
    properties (Constant)
        %-USER FOLDER TO SAVE IN------------------------------------------
        defaultUser             = 'muxika';
        %-DRIVE TO SAVE IN
        drive                   = 'E:';
        %-MICROMANAGER AND MICROSCOPE CONTROL PROPS------------------------
        %path to uManager app files
        micromanagerPath        = 'C:\Users\muxika\Documents\MATLAB\ScopeScript-01112022\binaries\Micro-Manager-1.4\';
        %path to uManager hardware configuration
        configPath              = 'C:\Users\muxika\Documents\MATLAB\ScopeScript-01112022\binaries\microscope_config.cfg';
        bufferSize              = 1000;
        % com port for custom TTL control
        fcPiezoCircuitCOMPort   = 'COM10';    
        fcPiezoCircuitBaudRate  = 115200;
        % com port for ScopeLED source
        mmScopeLEDCOMPort       = 'COM5';
        mmScopeLEDBaudRate      = 115200;
        %-TIF SAVING PARAMS------------------------------------------------
        saveParams              = {'tif', 'Compression', 'none'};
        %-SENSOR DEFECT CORRECTION FEATURE OF HAMAMATSU sCMOS -----------------------------------------
        sensorDefectCorrection  = true;
    end
    
    methods
        function obj = scopeParams(varargin)
            % fcScope = scopeParams('saveStage') then this will save the stage position
            % fcScope = scopeParams() doesn't save stage position
            if nargin == 1
                obj.stagePos    = getStagePos();
            else
                obj.stagePos    = [];
            end
            obj.currentDate = returnDate();
            obj.pfsOffset   = getPFSOffset();
            obj.currentDateTime = datetime('now');
        end
        
        function expPath = returnPath(obj)
                expPath = [obj.drive filesep obj.defaultUser filesep obj.currentDate filesep];
        end
    end
end
