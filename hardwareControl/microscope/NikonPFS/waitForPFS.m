function [] = waitForPFS(varargin)
%WAITFORPFS checks the PFS status is 'Locked in focus' for the majority of
%the time specified by N samples passing threshold, until timeout is reached.
% if offset is provided waitForPFS(offset), then this will set the offset and wait for settling

fcScope = scopeParams();
global ti2;
try
    if nargin==1
       pfsOffset = varargin{1}; 
       if isempty(pfsOffset)
           return;
       end
       ti2.iPFS_OFFSET = pfsOffset;
    end
    ti2.iPFS_SWITCH = 1;
    N       = fcScope.waitForPFS_N;
    thresh  = fcScope.waitForPFS_thresh;
    timeout = fcScope.waitForPFS_timeout;
    data = zeros(N,1,'uint8');
    doesItPass = 0;
    tic;
    % m is the number of tick marks to display
    m = 80;
    chunks = round(N/m);
   
    while (doesItPass == 0 && toc < timeout)
        fprintf('waiting for PFS to settle\n\n');
        for i = 1:N
            data(i) = strcmp(num2str(get(ti2,'iPFS_STATUS')),'778');
            if mod(i,chunks) == 0
                if sum(data(i:-1:i-chunks+1))==chunks
                    fprintf('\b*\n');
                else
                    fprintf('\b|\n');
                end
            end
        end
        data = mean(data);
        doesItPass =  data >= thresh;
    end
    if toc > timeout
        warning('PFS timed out');
        turnOffPFS();
    end
catch
    warning('PFS returned an error');
end
end

