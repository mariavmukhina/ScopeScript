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

``setupChannel `` sets the appropriate channel with correct energyLevel: ``setupChannel()`` lists all the channels available; ``setupChannel('channel',energy)`` sets a channel with intensity[%] = energy, the channel can be either PL or BF; ``setupChannel('channel',{energy1,energy2})`` sets a channel with multiple PL excitation bands; for PL channel, ``setupChannel `` also switches the filter cube 

`` stageAppend `` allows to save multiple XY locations of the microscope stage alonside corresponding PFS offsets to the global variable `stageCoordinates`; the stageCoordinates list is then used to execute fcScopes (Z stacks) at the selected locations as a timeLapse; default time interval between fcScopes at different locations is 5 sec, it can also be provided as an argument, e.g. `stageAppend(10)`

`` stageClear `` clears the global variable `stageCoordinates`

`` waitForPFS `` checks if the PFS status is 'Locked in focus' for the time specified by N samples passing threshold, until timeout is reached; if offset is provided `waitForPFS(offset)`, then this will set the offset (focal plane) and wait for settling; PFS is switched off between 3D z stacks and `waitForPFS` is called between z stacks to ensure that PFS is ON and the focus is found

`` finishExperiment `` run this function at the end of an experiment to turn off all the LEDs

### Imaging Control


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
