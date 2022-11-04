function fileLocation = executeContZCommand(flattenedInstructions,fcScope,streamNFrames)
%EXECUTECONTZCOMMAND Summary of this function goes here
%   Detailed explanation goes here

display('----executeContZCommand()------');
Nframes = flattenedInstructions.N*streamNFrames;
%% open all shutters since illumination is TTL controlled
openTurretShutter();
%% if pfs state is true, wait for it to settle before z stack
currentPFSState = getPFSState();
if currentPFSState
    waitForPFS();
end
%% prep microscope for zstack
turnOffPFS();
fcScope.setExposure();

%% display system parameters that z stack will do
if mmc.getCameraDevice == 'C13440'
    display(['exposure is ' num2str(getExposure) 'ms with sensor read out time of ' num2str(getSensorReadOutTime()*1000) 'ms']);
elseif mmc.getCameraDevice == 'Andor'
    display(['exposure is ' num2str(getExposure) 'ms with sensor read out time of ' num2str(getSensorReadOutTime()) 'ms']);
end
        
display(['streaming ' num2str(Nframes) ' frames consisting of:']);


display('1)');
currComandAsString = insertAStringBetweenCells(',',[flattenedInstructions.commands{1}]);
fprintf('\b protocol: %s\n',currComandAsString);
currZStackParams = ['N:' num2str(flattenedInstructions.dacInstructions{1}.N) ...
    ' [' insertAStringBetweenCells(',',num2cell(flattenedInstructions.mergedZSteps)) ']'];
fprintf('   %s\n',currZStackParams);
fprintf('   TTL triggers: %s\n',insertAStringBetweenCells(',',flattenedInstructions.commands{2}));



%% take z stack and parse the output
metaDataList = generateMetaDataForContZStack(flattenedInstructions,fcScope);
waitForSystem();
resetZStack();
if iscell(flattenedInstructions.commands{2})
   numTTLs = numel(flattenedInstructions.commands{2}); 
else
   numTTLs = 1;
end
zSteps = flattenedInstructions.dacInstructions{1}.N / numTTLs;
% generate filenames based on TTL triggers -> waveIndex
TTLtriggers = flattenedInstructions.commands{2};
global masterFileMaker;
if iscell(TTLtriggers)
    currfilename = cell(numel(TTLtriggers),1);
    for i = 1:numel(TTLtriggers)
       currfilename{i} =  masterFileMaker.generateFileName(fcScope,'TTLchannel',TTLtriggers{i});
    end
else
currfilename = {masterFileMaker.generateFileName(fcScope,'TTLchannel',TTLtriggers)};
end

writeStreamParsed(currfilename,streamNFrames,flattenedInstructions.commands{2},zSteps,metaDataList);
fileLocation = returnFilePath(currfilename{1});
%% if pfs state was on, turn it back on and wait for it to settle
if currentPFSState
    waitForPFS();
end

end

