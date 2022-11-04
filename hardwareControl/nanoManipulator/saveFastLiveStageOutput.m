function saveFastLiveStageOutput(Zpositions,timestamps)
    
    global liveStageONOFF
    global masterFileMaker
    
    if  liveStageONOFF == 1
        ZStagePositionsToFile = Zpositions; % save in 10-8 m
        timeStampToFile = (timestamps(:,5)*60+timestamps(:,6))*1000; % save in msec
        fileName = masterFileMaker.generateLiveStageFileName('0');
        disp('saving liveStage output')
        save(fileName,'ZStagePositionsToFile','timeStampToFile');
    end
end