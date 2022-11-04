function [varargout] = printAvailableBrightFieldChannels()
%PRINTAVAILABLEBRIGHTFIELDCHANNELS prints available brightfield channels

colorsFromManual = ['3000K';'4300K';'6500K';'Red  ';'Green';'Blue '];  
presetColors      = cellstr(colorsFromManual);

if nargout ==0
   disp(['brightfield channels: ' [insertAStringBetweenCells('BrightField,',presetColors) 'BrightField']]);
elseif nargout ==1
    varargout{1} = presetColors;
else
    
end

end

