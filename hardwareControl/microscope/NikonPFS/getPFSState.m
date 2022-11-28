function pfsState = getPFSState()
%GETPFSSTATE Summary of this function goes here
%   Detailed explanation goes here
global ti2;

global liveStageONOFF

if liveStageONOFF == 0

    if get(ti2,'iPFS_STATUS') == 778
        pfsState = true;
    else    
        pfsState = false;
    end

else
    pfsState = false;

end
end

