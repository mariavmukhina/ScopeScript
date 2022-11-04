function createExperimentFolder()
fcScope = scopeParams();
        folderName = ['E:' filesep 'muxika' filesep returnDate() '-' fcScope.defaultExpFolder '-' fcScope.defaultSampleName filesep 'liveStage' filesep];
        if ~exist(folderName,'dir')
            mkdir(folderName);
        end
end