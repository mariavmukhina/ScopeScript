function [] = printAllSettings()
%PRINTALLMMSETTINGS spits out all the microscope settings 

global mmc;
% get all loaded device
vals = mmc.getLoadedDevices();
nikon = cell(vals.size,1);
for i = 0:vals.size-1
    Device.name = vals.get(i);
    props = mmc.getDevicePropertyNames(Device.name);
    deviceProps = cell(props.size,1);
    allowedProps = cell(props.size,1);
    lowerLimProps = cell(props.size,1);
    upperLimProps = cell(props.size,1);
    readOnlyProps = cell(props.size,1);
    % get property stuff
    for j = 0:props.size-1
       deviceProps{j+1} = props.get(j);
       % allowed
       allowed = mmc.getAllowedPropertyValues(Device.name,deviceProps{j+1});
       allowedVals = cell(allowed.size,1);
       % lowerLim
       lowerLim = mmc.getPropertyLowerLimit(Device.name,deviceProps{j+1});
       % upperLim
       upperLim = mmc.getPropertyUpperLimit(Device.name,deviceProps{j+1});
       % readOnly?
       readOnly = mmc.isPropertyReadOnly(Device.name,deviceProps{j+1});
       for k = 0:allowed.size-1
           allowedVals{k+1} = allowed.get(k); 
       end
       allowedProps{j+1} = allowedVals;
       lowerLimProps{j+1} = lowerLim;
       upperLimProps{j+1} = upperLim;
       readOnlyProps{j+1} = readOnly;
    end
    
    % create structure that holds microscope information
    Device.props = deviceProps;
    Device.allowed = allowedProps;
    Device.lowerLims = lowerLimProps;
    Device.upperLims = upperLimProps;
    Device.readOnlys = readOnlyProps;
    nikon{i+1} = Device;
end

%% spit out the microscope parameters
for i = 1:numel(nikon)
    % device name
    disp(['device:' char(nikon{i}.name)]);
    % property list
    for j = 1:numel(nikon{i}.props)
        allowedText = printCellArray(nikon{i}.allowed{j});
        disp(['   -prop:' char(nikon{i}.props{j}) ...
            '  limits[' ...
            num2str(nikon{i}.lowerLims{j}) ',' ...
            num2str(nikon{i}.upperLims{j}) ']' ...
            ' readOnly?(' num2str(nikon{i}.readOnlys{j}) ')' ...
            ' allowed[' allowedText ']']);
    end
    
end


end

function [text] = printCellArray(cellObj)
if isempty(cellObj)
   text = '';
   return;
end
text = {};
for i = 1:numel(cellObj)
    curr = char(cellObj{i});
    text{end+1} = curr;
    text{end+1} = ',';
end
text = strcat(text{:});
end
