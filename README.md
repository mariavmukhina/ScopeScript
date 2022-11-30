# ScopeScript: Fast Matlab Microscope with Custom Hardware Controller

ScopeScript is a Matlab package for the control of microscopy setup. Custom hardware [controller](https://github.com/mariavmukhina/Custom_TTL_Controller_for_Microscope) is at the heart of this setup for the fastest acquisition in 4D. ScopeScript communicates with Nikon Ti-2 microscope through Matlab-only device adapter and uses uManager device adapters to connect to all periphery devices. ScopeScript also includes software for PI Nanocube nanomanipulator to seamlessly integrate image acquisition with mechanical stimulation of the sample with nanoscale precision. 

This software is a substitution for Nikon's $25K NIS-Elements.

Have a question? Get in touch!
You can email me at mmukhina@fas.harvard.edu, or raise a support [issue](https://github.com/mariavmukhina/ScopeScript/issues/new?assignees=mariavmukhina&labels=help+wanted&template=support-request.md&title=%5BSUPPORT%5D).

I inhereted the first version of the package from Frederick Chang, a former PhD student in Kleckner Lab at Harvard University.

------------------

## Installation

ScopeScript was tested with Matlab 2017a and requires Parallel Computing Toolbox and Statistics and Machine Learning Toolbox. The latter is only needed for camera calibration. In addition, ScopeScript uses uManager 1.4 (included with the package), Nikon Ti-2 SDK (can be obtained at nisdk.net), PI (Physik Instrumente) MATLAB Driver GCS2 for the controller of Nanocube nanomanipulator (optional).

(1) install Nikon Ti2 SDK and go to Matlab to register Nikon Ti2 ActiveX control in Windows:
```
cd 'C:\Program Files\Nikon\Ti2-SDK\bin';           
!regsvr32 /s NkTi2Ax.dll;
```
(2) create microscope hardware configuration in uManager and export .cfg file;

(3) install PI_MATLAB_Driver_GCS2_Setup.exe (optional, only needed for the nanomanipulator);

(4) in scopeParams.m, set the correct properties.

## (Incomplete) ScopeScript Reference

`` scopeParams `` is a class containing all parameters for image acquisition. Define your experiment here.

### Hardware Control

``  startMicroscope() `` creates µManager cmmcore object, startups the microscope and initializes other hardware

`` initMicroscope() `` sets up Nikon Ti-2 microscope, LEDs and cameras, initiates Nanocube; global variable `showROI` defines ROI for `executeFunctions` (z stack acquisition) and `doTimeLapse`, also `showROI` is shown in live mode executed by `livePL` and `liveBF`, the full ROI is used by default

``setupChannel() `` sets the appropriate channel with correct energyLevel: ``setupChannel()`` lists all the channels available; ``setupChannel('channel',energy)`` sets a channel with intensity[%] = energy, the channel can be either PL or BF; ``setupChannel('channel',{energy1,energy2})`` sets a channel with multiple PL excitation bands; for PL channel, ``setupChannel `` also switches the filter cube 

`` stageAppend() `` allows to save multiple XY locations of the microscope stage alonside corresponding PFS offsets to the global variable `stageCoordinates`; the stageCoordinates list is then used to execute fcScopes (Z stacks) at the selected locations as a timeLapse; default time interval between fcScopes at different locations is 5 sec, it can also be provided as an argument, e.g. `stageAppend(10)`

`` stageClear() `` clears the global variable `stageCoordinates`

`` waitForPFS() `` checks if the PFS status is 'Locked in focus' for the time specified by N samples passing threshold, until timeout is reached; if offset is provided `waitForPFS(offset)`, then this will set the offset (focal plane) and wait for settling; PFS is switched off between 3D z stacks and `waitForPFS()` is called between z stacks to ensure that PFS is ON and the focus is found; in very fast timelapses with time between two z stacks less than `waitForPFS_timeout` parameter in `scopeParams`, `waitForPFS()` can hold up the acquisition of the data, in these cases, the user can adjust `waitForPFS_timeout` to zero to basically stop `waitForPFS()` from running

`` liveStage() `` measures Z positions of the microscope stage during acquisition of one camera frame and saves them to file; also it plays sound if position of the stage changes for more than 1 µm; temporal resolution [measurements/frame] is defined by the global variable `liveStageONOFF`

`` fastLiveStage() `` measures Z position of the microscope stage at the temporal resolution 1 measurement/frame

`` generateWave() `` defines the motion of NanoCube along z axis during pressure application based on the parameters defined in `scopeParams`; function is called if the parameter `generateWave` is added to `function[i]` definition in `scopeParams`; `generateWave()` sends instructions to Nanocube controller; parameters for the pressure wave are defined in `scopeParams`

``moveToInitialPosition() `` moves Nanocube to initial position, default is x = 50, y = 50, z = 100, otherwise parameters are read from `scopeParams`

`` finishExperiment() `` turns off all the LEDs and should be run at the end of an experiment

### Imaging Control

`` liveBF() `` runs imaging in the BF channel in a current focal plane with real-time display, data are not saved; BF channel can be either preselected with setupChannel or specified as function input: liveBF('GreenBrightField',50); if the channel parameters are provided as an input and function `executeFunctions` is called during real-time streaming (see `doLive`), the scope will return to this predefined channel once `executeFunctions` is completed

`` livePL() `` runs imaging in the PL channel in a current focal plane with real-time display, data are not saved; PL channel can be either preselected with setupChannel or specified as function input: livePL('1-QDot',100); if the channel parameters are provided as an input and function `executeFunctions` is called during real-time streaming (see `doLive`), the scope will return to this predefined channel once `executeFunctions` is completed

`` doLive() `` starts the stream from the camera and displays it in Matlab figure; keyboard 'q' -> quits; keyboard 'p' -> pauses; keyboard 'e' -> executes function predefined in `scopeParams` by `executeOnly`; if channel and energy are provided as arguments `doLive({channel,energy})`, after the function execution, the scope returns to the channel defined by these arguments; keyboard 's' -> saves XY coordinates to the global variable `stageCoordinates` (see `stageAppend`); keyboard '1-9' -> moves to position in `stageCoordinates` list

`` executeFunctions() `` takes a single z stack defined by `function[i]` in `scopeParams`; if called without arguments, it executes the functions specified by `executeOnly` in `scopeParams`; the function/s to execute can be provided by calling `executeFunctions(fcScope)` or `executeFunctions({fcScope1,fcScope2})`, where `fcScope` is a number of `function[i]` from `scopeParams`

`` executeZCommand() `` acquires N frames specified `function[i]` in `scopeParams`, then parses the data to `zCommandOutput`; also this function cotrols Nikon PFS during z stack acquisition; if the global variable `liveStageONOFF = 1`, it also records Z positions of the stage (see `liveStage`)

`` executeFunctionGivenCommand() `` initiates execution of the function specified in `function[i]` in `scopeParams`; by default, all `function[i]`s invoke `takeA3DStack`; however, `executeFunctionGivenCommand()` is where additional functions can be invoked if they are added to the definition of `function[i]`; the current version of `executeFunctionGivenCommand()` allows to execute `generateWave` in parallel with `takeA3DStack` (see `function[10]` in `scopeParams`)




### Data Management


### Camera Calibration




livePhase                  % run live acquisition with Dia illumination
liveFlour                   % run live acquisition with LED illumination
liveLaser                   % run live acquisition with laser illumination

executeFunctions       % runs experiments pre-defined in fcScopeParams
doTimeLapse             % runs time lapses of experiments pre-defined in fcScopeParams
finishExperiment        % turns off all LEDs, run every time at the end of imaging session (after the cameras are turned off)


 
   
case {'1-QDot'}  % put here name of filter cube, names of all filter cubes can be listed by calling function 'printAvailableFilterCubes()'
        mmc.setProperty('pE4000','SelectionA',1);  % turn on all necessary channels
        mmc.setProperty('pE4000','SelectionB',0);
        mmc.setProperty('pE4000','SelectionC',0);
        mmc.setProperty('pE4000','SelectionD',0);

        mmc.setProperty('pE4000','ChannelA',365);  % choose the wavelength for all active channels

        mmc.setProperty('pE4000','IntensityA',energy);  % turn on selection of intensity for all active channels
        mmc.setProperty('pE4000','IntensityB',0);
        mmc.setProperty('pE4000','IntensityC',0);
        mmc.setProperty('pE4000','IntensityD',0);


Next, you need to choose appropriate triggers in fcScopeParams. For the example above, you need to trigger channel A: 

        setChannel1  = {{'1-QDot',100},{'4300KBrightField',2}};      % commands the scope to use the sequence of 2 different illumination modes (photoluminescence with excitation in QDot channel and brightfield with illumination with 4300K light)
        function1    = {'takeA3DStack',{'zStack1','ChATTL','zStack1','BrightFieldTTL'}};   % defines parameters of stacks for both illumination modes (stacks are taken in sequence)
        timePoints1  = 0:10:60; % defines parameters of the time lapse delay[sec]:take stack every [sec]:for [sec]
        exposure1    = 100;

The following line defines which recipe to run:
        executeOnly = [1];%[8,4,3,1];

Note that z steps in time-lapses are defined in DAC units, not nm. 

        % z step is defined in DAC units, not nanometers
        %-zStack recipes---------------------------------------------------
        zStack1_N   = 11;
        zStack1_dz  = 500;
        zStack1_z0  = 0;

PI piezo stage was not calibrated to get the conversion factor, but the following ratio can be used as a guide: 

        /* writes 2's complement value to the 16 bit dac
        useful numbers:
        0V = -32768   // 65536 range corresponds to the full range of the stage (220 um)
        5V = 0
        10V = 32767
        250nm step is 75 units (74.473) NB: from an experiment 100 nm is 35 units
        */

Code allows to additionally accelerate the piezo stage. It can be done by sending triangle pulses:



Acceleration is defined by additional voltage ff1_deltaUp and ff1_deltaDown. For each step size they have to be determined empirically. If these parameters are absent for pre-selected step size, z stack will be taken without acceleration.

        ff1_dz          = 300;
        ff1_deltaUp     = 2230;
        ff1_delayUp     = 1;
        ff1_deltaDown   = -1000;
        ff1_delayDown   = 1;

It was found that additional acceleration works only in open-loop mode (faster but less accurate). I could not find a parameters that would allow to decrease acquisition time and keep the stage stable. By default, the stage is set up to slightly slower closed-loop mode to ensure stability, additional acceleration is not used. 
