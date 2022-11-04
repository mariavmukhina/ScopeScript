function [Zposition,timestamp] = fastLiveStage()
%fastLiveStage measures Z position of the microscope stage at the temporal resolution 1 measurement/frame
%for multiple measurements per frame use liveStage()

global ti2;
global liveStageONOFF;
if  liveStageONOFF == 1
    Zposition = get(ti2,'iZPOSITION'); %read Z position, resolution 10-8 m
    timestamp =  clock;
end
end