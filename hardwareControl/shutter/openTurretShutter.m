function [] = openTurretShutter()
fcScope = scopeParams();
pauseTimeShutters = fcScope.pauseTimeShutters;
global ti2;
if get(ti2,'iTURRET1SHUTTER') == 0 
    ti2.iTURRET1SHUTTER = 1;
    disp(['opened EPI shutter, pausing ' num2str(pauseTimeShutters) ' secs']);
    pause(pauseTimeShutters);
end
end
