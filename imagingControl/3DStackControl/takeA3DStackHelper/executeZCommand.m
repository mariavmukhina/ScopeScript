function [zCommandOutput] = executeZCommand(flattenedInstructions,fcScope)
%EXECUTEZCOMMAND will acquire N frames specified by command in fcScope then parse it in zCommandOutput
% If livestage on, it will also record Z positions of the stage

global mmc;
global ti2;


ttlPiezo();
disp('----executeZCommand()----------');
Nframes = flattenedInstructions.N;
%% open all shutters since illumination is TTL controlled
openTurretShutter();
%% if pfs state is true, wait for it to settle before z stack
currentPFSState = getPFSState();
if currentPFSState
   waitForPFS(); 
end

%% check the lightpath
if mmc.getCameraDevice() == 'Andor'
    ti2.LightPath.Value = 2;
elseif mmc.getCameraDevice() == 'C13440'
    ti2.LightPath.Value = 4;
end

%% display system parameters that z stack will do
if mmc.getCameraDevice == 'C13440'
    disp(['exposure is ' num2str(getExposure) 'ms with sensor read out time of ' num2str(getSensorReadOutTime()) 'ms']);
elseif mmc.getCameraDevice == 'Andor'
    disp(['exposure is ' num2str(getExposure) 'ms with sensor read out time of ' num2str(getSensorReadOutTime()) 'ms']);
end
disp(['streaming ' num2str(Nframes) ' frames consisting of:']);
for i = 1:2:numel(flattenedInstructions.commands)
    disp([num2str((i-1)/2+1) ')']);
    currComandAsString = insertAStringBetweenCells(',',[flattenedInstructions.commands{i}]);
    fprintf('\b protocol: %s\n',currComandAsString); 
    currZStackParams = ['N:' num2str(flattenedInstructions.dacInstructions{(i-1)/2+1}.N) ...
        ' [' insertAStringBetweenCells(',',num2cell(flattenedInstructions.dacInstructions{(i-1)/2+1}.mergedZSteps)) ']'];
    fprintf('   %s\n',currZStackParams);
    fprintf('   TTL triggers: %s\n',insertAStringBetweenCells(',',flattenedInstructions.commands{i+1}));
end

%% prep microscope for zstack
clearBuffer();
if ~isequal(currComandAsString,'zStackZeroStep')
    turnOffPFS();
end

%% take z stack and parse the output
waitForSystem();
if ~isequal(currComandAsString,'zStackZeroStep') 
    resetZStack();
end
streamAcq = getStream(Nframes);
zCommandOutput = parseZStream(streamAcq,flattenedInstructions,fcScope);
% generate meta data for each zstack taken in the stream
for i= 1:numel(zCommandOutput)
   zCommandOutput{i}.zMeta = genMetaData(fcScope, zCommandOutput{i}.zMeta);

end 
%% if generateWave() is called in the channel, stop wave generator
stopWaveGenerator();

%% save output
global masterFileMaker;
for i = 1:numel(zCommandOutput)
   % save each parsed output
   TTLtrigger = regexp(zCommandOutput{i}.zMeta,'TTLtrigger: \w+','match');
   TTLtrigger = TTLtrigger{1};
   TTLtrigger = TTLtrigger(13:end);
   LEDlevels = regexp(zCommandOutput{i}.zMeta,'LED levels: \w+','match');
   if ~isempty(LEDlevels)
       LEDlevels = LEDlevels{1};
       LEDlevels = LEDlevels(13:end);
   end
   currfilename = masterFileMaker.generateFileName(fcScope,'TTLchannel',TTLtrigger,'LEDlevels',LEDlevels);
   exportSingleTifStack(currfilename,zCommandOutput{i}.data,zCommandOutput{i}.zMeta);
end

%% if pfs state was on, turn it back on and wait for it to settle
if currentPFSState
   waitForPFS(); 
end

%% set BF configuration (EM =0) if Andor camera is selected
BF();
%% switch DIA LED to manual
if contains(lower(TTLtrigger),'brightfield')
    setBrightFieldManual('4300K',0);
end
end

