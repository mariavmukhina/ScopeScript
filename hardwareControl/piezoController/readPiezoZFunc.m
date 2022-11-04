function [] = readPiezoZFunc()
global mmc;

comPort = scopeParams.fcPiezoCircuitCOMPort;
mmc.setSerialPortCommand(comPort,'p','');
pause(1);
serialOutput = char(mmc.getSerialPortAnswer(comPort,char(10)));
serialOutput = textscan(serialOutput,'%s %u %s %u');
zIndexStart = serialOutput{2};
zIndexEnd   = serialOutput{4};
serialOutput = char(mmc.getSerialPortAnswer(comPort,char(10)));
serialOutput = textscan(serialOutput,'%s %s %s %s %s %s %s','Delimiter',',');
dataLabels = cellfun(@(x) x, serialOutput);
display([dataLabels{1} dataLabels{2} dataLabels{3} dataLabels{4} dataLabels{5} dataLabels{6} dataLabels{7}])
dataHolders = {};
while 1
    serialOutput = char(mmc.getSerialPortAnswer(comPort,char(10)));
    
    if isequal(char(serialOutput),'EOT');
        break;
    end
    serialOutput = textscan(serialOutput,'%u %u %u %u %d %u %d','Delimiter',',');
    dataHolders{end+1} = serialOutput;
end
dataHolders{zIndexStart+1:zIndexEnd+1}
display(['zIndexStart:' num2str(zIndexStart) ' zIndexEnd:' num2str(zIndexEnd)]);

end
