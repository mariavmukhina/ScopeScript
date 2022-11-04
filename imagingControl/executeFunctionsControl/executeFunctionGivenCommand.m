function [] = executeFunctionGivenCommand(functioni,fcScope)
%EXECUTEFUNCTIONGIVENCOMMAND Summary of this function goes here
%   Detailed explanation goes here

global liveStageONOFF
func = str2func(functioni{1});
argList = functioni{2};
if ~isempty(functioni{3})
    global masterFileMaker
    liveStageONOFF = functioni{4};
    masterFileMaker.createLiveStageFolder(fcScope);
    generateWave();
else
    liveStageONOFF = 0;   
end
func(argList,'fcScope',fcScope);

end

