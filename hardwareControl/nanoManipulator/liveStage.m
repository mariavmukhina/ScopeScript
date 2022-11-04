function liveStage(exposureAndReadout,varargin)
%liveStage measures Z positions of the microscope stage during acquisition of one camera frame and saves them to file
%also it plays sound if position of the stage changes for more than 1 µm
%temporal resolution [measurements/frame] is defined by the global variable liveStageONOFF

global liveStageONOFF

if liveStageONOFF > 1
    global masterFileMaker
    global ti2
    frameCounter = cell2mat(varargin);
    N = liveStageONOFF; % resolution in recordings/frame
    
    if exposureAndReadout <= 10
       warning('Exposure is too short, decrease resolution of liveStage');
    else
        soundSignal = load('splat.mat');
        if isempty(frameCounter)
            Nmeasurements        = 1;
        elseif ~isempty(frameCounter) && frameCounter == 0
            Nmeasurements        = N-2; %4 for 100 ms camera exposure; 48 for 1 s, 4 for 15ms,
        elseif ~isempty(frameCounter) && frameCounter ~= 0
            Nmeasurements        = N; % 5 for 100 ms; 50 for 1 s, 6 for 15ms,
        end
        %!!!!!!!!!!!! set resolution to Nmeasurements+1 in periodOfMeasurements
        periodOfMeasurements = round((exposureAndReadout/1000/N+1),3); % /1000 because default units of Matlab timer are sec, next /(N+1) is resolution in time
        ZStagePositions = get(ti2,'iZPOSITION');
        % !NB: Matlab timer prescision is limited to 1msec
        timestamp = clock;

        % setup period and timer
        % clear timers
        tStage = timerfind('Name','liveStage');
        delete(tStage);
        % create new timer
        tStage = timer();
        set(tStage,'Name','liveStage');
        set(tStage,'ExecutionMode','fixedRate');
        set(tStage,'Period',periodOfMeasurements);
        set(tStage,'TasksToExecute',Nmeasurements);
        set(tStage,'BusyMode','drop');
        set(tStage,'TimerFcn',{@ZposTrack});
        set(tStage,'StopFcn',{@stopZposTrack});

        start(tStage);
    end
end 

function ZposTrack(obj,event)
    timestamp(end+1,:) = clock;                       % read timepoints, resolution 10-3 sec
    ZStagePositions(1,end+1) = get(ti2,'iZPOSITION'); %read Z positoin, resolution 10-8 m
    if abs(ZStagePositions(1,end)-ZStagePositions(1,end-1)) > 50
        sound(soundSignal.y);
    end
end

function stopZposTrack(obj,event)
    if ~isempty(frameCounter)
        ZStagePositionsToFile = transpose(ZStagePositions(1,2:end)); % save in 10-8 m
        timeStampToFile = (timestamp(2:end,5)*60+timestamp(2:end,6))*1000; % save in msec
        currfilename = masterFileMaker.generateLiveStageFileName(num2str(frameCounter));
        disp('saving liveStage output')
        save(currfilename,'ZStagePositionsToFile','timeStampToFile');
        clear timestamp;
    end
end

end

