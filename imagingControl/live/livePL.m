function [] = livePL(varargin)
%LIVEPL runs imaging in the PL channel in a current focal plane with real-time display, data are not saved
% PL channel can be either preselected with setupChannel or specified as function input: livePL('1-QDot',100)

if ~isempty(varargin)
   channel =  varargin{1};
   energy =  varargin{2};
   setupChannel(channel,energy);
else
    channel = [];
    energy = [];
end
stopStreaming();
disp('--livePL()-----------------------');
fcScope = scopeParams;
% save current ROI
oldROI = getROI();
%clearROI();
setExposure(fcScope.cameraExposureLivePL);
openTurretShutter();
printScopeSettings();
PL();
doLive(oldROI,channel,energy);
turnOffAllLEDs;
setROI(oldROI);
fprintf('\n\n');
BF();
end

