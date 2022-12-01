# ScopeScript: Fast Matlab Microscope with Custom Hardware Controller

ScopeScript is a Matlab package for the control of microscopy setup. Custom hardware [controller](https://github.com/mariavmukhina/Custom_TTL_Controller_for_Microscope) is at the heart of this setup for the fastest acquisition in 4D. ScopeScript communicates with Nikon Ti-2 microscope through Matlab-only device adapter and uses uManager device adapters to connect to all periphery devices. ScopeScript also includes software for PI Nanocube nanomanipulator to seamlessly integrate image acquisition with mechanical stimulation of the sample with nanoscale precision. 

This software is a substitution for Nikon's $25K NIS-Elements.

Have a question? Get in touch!
You can email me at mmukhina@fas.harvard.edu, or raise a support [issue](https://github.com/mariavmukhina/ScopeScript/issues/new?assignees=mariavmukhina&labels=help+wanted&template=support-request.md&title=%5BSUPPORT%5D).

I inhereted the first version of the package from Frederick Chang, a former PhD student in Kleckner Lab at Harvard University.

## Kleckner Lab acknowledgement

Please acknowledge the Kleckner Lab in your publications. An appropriate wording would be:

"The microscope control software was provided by the laboratory of Nancy Kleckner at Harvard University, funded in part by National Institutes of Health (NIH) grant R35GM136322."

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

`` startMicroscope() `` creates µManager cmmcore object, startups the microscope and initializes other hardware

`` initMicroscope() `` sets up Nikon Ti-2 microscope, LEDs and cameras, initiates Nanocube; global variable `showROI` defines ROI for `executeFunctions` (z stack acquisition) and `doTimeLapse`, also `showROI` is shown in live mode executed by `livePL` and `liveBF`, the full ROI is used by default

`` setupChannel() `` sets the appropriate channel with correct energyLevel: `setupChannel()` lists all the channels available; `setupChannel('channel',energy)` sets a channel with intensity[%] = energy, the channel can be either PL or BF; `setupChannel('channel',{energy1,energy2})` sets a channel with multiple PL excitation bands; for PL channel, `setupChannel` also switches the filter cube; `setupChannel` sets the wavelength and intensity for the channel, LED is turned on later on in acquisition by sending TTL trigger; all BF channels have the same `BrightFieldTTL` trigger; PL channels have different triggers depending on their wavelength (see `scopeParams` and manual for CoolLED), also multiple wavelengths can be triggered at once

`` stageAppend() `` allows to save multiple XY locations of the microscope stage alonside corresponding PFS offsets to the global variable `stageCoordinates`; the stageCoordinates list is then used to execute fcScopes (Z stacks) at the selected locations as a timeLapse; default time interval between fcScopes at different locations is 5 sec, it can also be provided as an argument, e.g. `stageAppend(10)`

`` stageClear() `` clears the global variable `stageCoordinates`

`` waitForPFS() `` checks if the PFS status is 'Locked in focus' for the time specified by N samples passing threshold, until timeout is reached; if offset is provided `waitForPFS(offset)`, then this will set the offset (focal plane) and wait for settling; PFS is switched off between 3D z stacks and `waitForPFS()` is called between z stacks to ensure that PFS is ON and the focus is found; in very fast timelapses with time between two z stacks less than `waitForPFS_timeout` parameter in `scopeParams`, `waitForPFS()` can hold up the acquisition of the data, in these cases, the user can adjust `waitForPFS_timeout` to zero to basically stop `waitForPFS()` from running

`` liveStage() `` measures Z positions of the microscope stage during acquisition of one camera frame and saves them to file; also it plays sound if position of the stage changes for more than 1 µm; temporal resolution [measurements/frame] is defined by the global variable `liveStageONOFF`

`` fastLiveStage() `` measures Z position of the microscope stage at the temporal resolution 1 measurement/frame

`` generateWave() `` defines the motion of NanoCube along z axis during pressure application based on the parameters defined in `scopeParams`; function is called if the parameter `generateWave` is added to `function[i]` definition in `scopeParams`; `generateWave()` sends instructions to Nanocube controller; parameters for the pressure wave are defined in `scopeParams`

``moveToInitialPosition() `` moves Nanocube to initial position, default is x = 50, y = 50, z = 100, otherwise parameters are read from `scopeParams`

`` finishExperiment() `` turns off all the LEDs; should be run at the end of an imaging sessions after all cameras are turned off

### Imaging Control

`` liveBF() `` runs imaging in the BF channel in a current focal plane with real-time display, data are not saved; BF channel can be either preselected with setupChannel or specified as function input: liveBF('GreenBrightField',50); if the channel parameters are provided as an input and function `executeFunctions` is called during real-time streaming (see `doLive`), the scope will return to this predefined channel once `executeFunctions` is completed

`` livePL() `` runs imaging in the PL channel in a current focal plane with real-time display, data are not saved; PL channel can be either preselected with setupChannel or specified as function input: livePL('1-QDot',100); if the channel parameters are provided as an input and function `executeFunctions` is called during real-time streaming (see `doLive`), the scope will return to this predefined channel once `executeFunctions` is completed

`` doLive() `` starts the stream from the camera and displays it in Matlab figure; keyboard 'q' -> quits; keyboard 'p' -> pauses; keyboard 'e' -> executes function predefined in `scopeParams` by `executeOnly`; if channel and energy are provided as arguments `doLive({channel,energy})`, after the function execution, the scope returns to the channel defined by these arguments; keyboard 's' -> saves XY coordinates to the global variable `stageCoordinates` (see `stageAppend`); keyboard '1-9' -> moves to position in `stageCoordinates` list

`` executeFunctions() `` takes a single z stack defined by `function[i]` in `scopeParams`; if called without arguments, it executes the functions specified by `executeOnly` in `scopeParams`; the function/s to execute can be provided by calling `executeFunctions(fcScope)` or `executeFunctions({fcScope1,fcScope2})`, where `fcScope` is a number of `function[i]` from `scopeParams`; if the global variable `stageCoordinates` is not empty, z stacks will be taken in each XY location (see `stageAppend`); for multiple fcScopes, the order will be (fcScope1(XY1),fcScope1(XY2),fcScope2(XY1),fcScope2(XY2))

`` executeZCommand() `` acquires N frames specified `function[i]` in `scopeParams`, then parses the data to `zCommandOutput`; also this function cotrols Nikon PFS during z stack acquisition; if the global variable `liveStageONOFF = 1`, it also records Z positions of the stage (see `liveStage`)

`` executeFunctionGivenCommand() `` initiates execution of the function specified in `function[i]` in `scopeParams`; by default, all `function[i]`s invoke `takeA3DStack`; however, `executeFunctionGivenCommand()` is where additional functions can be invoked if they are added to the definition of `function[i]`; the current version of `executeFunctionGivenCommand()` allows to execute `generateWave` in parallel with `takeA3DStack` (see `function[10]` in `scopeParams`)

`` doTimeLapse() `` takes z stacks defined by `function[i]` with intervals set by `timePoints[i]` in `scopeParams`; if called without arguments, it executes the functions specified by `executeOnly` in `scopeParams`; the function/s to execute can be provided by calling `doTimeLapse(fcScope)` or `doTimeLapse({fcScope1,fcScope2})`, where `fcScope` is a number of `function[i]` from `scopeParams`; if the global variable `stageCoordinates` is not empty, z stacks will be taken in each XY location (see `stageAppend`); for multiple fcScopes, the order will be timePoint1(fcScope1(XY1),fcScope1(XY2),fcScope2(XY1),fcScope2(XY2)), timePoint2(...)

`` stopTimeLapse() `` stops the timelapse by deleting the timer set by `doTimeLapse`; for very fast timelapses, in addition to calling `stopTimeLapse`, pressing pause button in Matlab interface may be necessary to stop the timelapse

### Data Management

`` masterFileGenerator `` is a class that globally regulates how the files generated during z stack acquisition are saved 

### Camera Calibration

`` testSaturation() `` runs live BF acquisition with maximum settings to be used by `runPhotonTransferCalibration` later on to ensure that camera sensor is not saturated

`` runCalibration() `` executes mean variance and dark frame measurement using the parameters from scopeParams and calculates the gain, offset, and noise per pixel; !!!! BEFORE STARTING you  need to calibrate the maximum light intensity by running `testSaturation` to make sure camera sensor does not saturate
