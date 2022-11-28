function createExperimentFolder()
fcScope = scopeParams();
        folderName = [fcScope.drive filesep fcScope.defaultUser filesep returnDate() '-' fcScope.defaultExpFolder '-' fcScope.defaultSampleName filesep 'liveStage' filesep];
        if ~exist(folderName,'dir')
            mkdir(folderName);
        end
end
