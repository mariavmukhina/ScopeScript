function [] = closeTurretShutter()
global ti2;
if get(ti2,'iTURRET1SHUTTER') == 1
    ti2.iTURRET1SHUTTER = 0;
end

end