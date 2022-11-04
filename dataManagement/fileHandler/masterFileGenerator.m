classdef masterFileGenerator < handle
    %MASTERFILEGENERATOR globally regulates how files are generated given an experiment
    % if it is not a timelapse
    % 1) check if name generated exists
    %    - if so, increment strain name
    % if it is a timelapse and it is a first timepoint
    % 1) check if timelapse folder exists
    %   - if so, increment timelapse folder
    % masterFileMaker = masterFileGenerator();
    % masterFileMaker.reset resets state
    % masterFileMaker.setStagePos(stagePos) sets stage pos 
    % masterFileMaker.setFunctionName(funcName) sets current function
    % folder
    % masterFileMaker.setupTimeLapseFolder(fcScope) creates a new timelapse
    % folder, this is called by whatever is setting up the timelapse
    
    properties
        functionFolder
        stagePos
        timeLapseFolder
        liveStageFolder
    end
    
    methods
        function obj = masterFileGenerator(varargin)
            obj.functionFolder = [];
            obj.stagePos = [];
            obj.timeLapseFolder = [];
            obj.liveStageFolder = [];
        end
        
        function obj = reset(obj)
            % reset back to empty state
            obj.functionFolder = [];
            obj.stagePos = [];
            obj.timeLapseFolder = [];
            obj.liveStageFolder = [];
        end
        
        function obj = setStagePos(obj,currStagePos)
            % set stage position
            obj.stagePos = currStagePos;
        end
        
        function obj = setFunctionName(obj,functionName)
            % setup function name to create folder
            obj.functionFolder = functionName;
        end
        
        function obj = setupTimeLapseFolder(obj,fcScope)
            % turn on timelapse annotation
            expPath       = fcScope.returnPath;
            expFolder     = fcScope.defaultExpFolder;
            expFolderPath = [expPath(1:end-1) '-' expFolder '-' fcScope.defaultSampleName];
            
            % check if timelapse folder exists, if so increment, if not
            % leave it be
            localFileMatchingFileName = getLocalFolders(expFolderPath,'doTimeLapse_[0-9]+');
            if isempty(localFileMatchingFileName)
                obj.timeLapseFolder = 'doTimeLapse_1';
            else
                returnMaxNumberRegexp = regexp(localFileMatchingFileName,'_[0-9]+$','match');
                % remove underscore
                returnMaxNumberRegexp = cellfun(@(x) str2double(x{1}(2:end)),returnMaxNumberRegexp);
                newNumber = max(returnMaxNumberRegexp) + 1;
                obj.timeLapseFolder = ['doTimeLapse_' num2str(newNumber)];
            end
            
        end
        
        function obj = createLiveStageFolder(obj,fcScope)
            subFoldersLiveStage = obj.genSubFolder(fcScope);
            if ~isempty(obj.functionFolder)
                subFoldersLiveStage = erase(subFoldersLiveStage,[obj.functionFolder filesep]);
            end
            currTimePoint = num2str(getTimerTimePoint());
            if isempty(currTimePoint)
                obj.liveStageFolder = [subFoldersLiveStage 'liveStage' filesep 't0' filesep];
            else
                obj.liveStageFolder = [subFoldersLiveStage 'liveStage' filesep 't' currTimePoint filesep];
            end
            mkdir(obj.liveStageFolder);
        end
        
        function folder = genSubFolder(obj,fcScope)
            % generates the sub folders given state variables
            expPath       = fcScope.returnPath;
            expFolder     = fcScope.defaultExpFolder;
            if isempty(obj.stagePos)
                stagePosFolder = [];
            else
                stagePosFolder = ['s' num2str(obj.stagePos)];
            end
            
            folder = [expPath(1:end-1) '-' expFolder '-' fcScope.defaultSampleName filesep obj.timeLapseFolder filesep obj.functionFolder filesep stagePosFolder];
            folder = removeDoubleFileSep(folder);
            folder = regexprep(folder,'-{2,}','-');
        end
        
        function filename = generateFileName(obj,fcScope,varargin)
            % generates filename given state variables and inputs
            % if strain name exist, increment the name
            p = inputParser;
            p.addParameter('channel',[],@ischar);
            p.addParameter('TTLchannel',[],@(x) true);
            p.addParameter('isBF',false,@logical);
            p.addParameter('LEDlevels',[],@(x) true);
            p.parse(varargin{:});
            input  = p.Results;
            channel   = input.channel;
            TTLchannel = input.TTLchannel;
            isBF    = input.isBF;
            LEDlevels = input.LEDlevels;

            if isempty(channel)
                channel = getCurrentFilterCube();
            end
            subFolders = obj.genSubFolder(fcScope);
            currTimePoint = getTimerTimePoint();
            annotatedName = genAnnotatedSampleName(fcScope,'timePoint',currTimePoint,'stagePos',obj.stagePos,'isBF',isBF,'channel',channel,'TTLchannel',TTLchannel,'LEDlevels',LEDlevels);
            filename = [subFolders filesep annotatedName];
            filename = removeDoubleFileSep(filename);
        end
        
        function filename = generateLiveStageFileName(obj,currFrameNumber)
            foldername = obj.liveStageFolder;
            filename = [foldername 'liveStage-frame' currFrameNumber '.mat'];
        end
    end
    
end

