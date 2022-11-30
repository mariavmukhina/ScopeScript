function [] = liveBF(varargin)
%LIVEBF runs imaging in the BF channel in a current focal plane with real-time display, data are not saved
% BF channel can be either preselected with setupChannel or specified as function input: liveBF('GreenBrightField',50)

if ~isempty(varargin)
   channel =  varargin{1};
   energy =  varargin{2};
   setupChannel(channel,energy);
else
    channel = [];
    energy = [];
end
stopStreaming();
disp('--liveBF()-----------------------');
%clearROI();
closeTurretShutter();
BF();
% save current ROI
oldROI = getROI();
clearROI();
fcScope = scopeParams;
setExposure(fcScope.cameraExposureLiveBF)
doLive(oldROI,channel,energy);
setBrightFieldManual('4300K',1);
disp('brightfield is set to manual 4300K');
fprintf('\n\n');
setROI(oldROI);
turnOffAllLEDs();

end

