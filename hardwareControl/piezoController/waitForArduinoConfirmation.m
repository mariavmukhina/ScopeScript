function confirmed = waitForArduinoConfirmation()
%WAITFORARDUINOCONFIRMATION

% wait for confirmation that circuit is ready
global mmc;
comPort = scopeParams.fcPiezoCircuitCOMPort;
tic;
while toc < 5
   try
        serialOutput = char(mmc.getSerialPortAnswer(comPort,char(10)));
        if strcmp(serialOutput,'ok')
            confirmed = true;
            return;
        end
   catch
        
   end
end
warning('arduino controller timed out in serial communication');
end

