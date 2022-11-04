function varargout = printCurrentLEDState(varargin)
%PRINTCURRENTLEDSTATE prints current CoolLED state

global mmc;

if char(mmc.getProperty('pE4000','ChannelA')) == '365'
   I365 = char(mmc.getProperty('pE4000','IntensityA'));
else
   I365 = '0';
end

if char(mmc.getProperty('pE4000','ChannelA')) == '385'
   I385 = char(mmc.getProperty('pE4000','IntensityA'));
else
   I385 = '0';
end

if char(mmc.getProperty('pE4000','ChannelA')) == '405'
   I405 = char(mmc.getProperty('pE4000','IntensityA'));
else
   I405 = '0';
end

if char(mmc.getProperty('pE4000','ChannelA')) == '435'
   I435 = char(mmc.getProperty('pE4000','IntensityA'));
else
   I435 = '0';
end

if char(mmc.getProperty('pE4000','ChannelB')) == '460'
   I460 = char(mmc.getProperty('pE4000','IntensityB'));
else
    I460 = '0';
end

if char(mmc.getProperty('pE4000','ChannelB')) == '470'
   I470 = char(mmc.getProperty('pE4000','IntensityB'));
else
   I470 = '0';
end

if char(mmc.getProperty('pE4000','ChannelB')) == '490'
   I490 = char(mmc.getProperty('pE4000','IntensityB'));
else
   I490 = '0';
end

if char(mmc.getProperty('pE4000','ChannelB')) == '500'
   I500 = char(mmc.getProperty('pE4000','IntensityB'));
else
   I500 = '0';
end

if char(mmc.getProperty('pE4000','ChannelC')) == '525'
   I525 = char(mmc.getProperty('pE4000','IntensityC'));
else
   I525 = '0';
end

if char(mmc.getProperty('pE4000','ChannelC')) == '550'
   I550 = char(mmc.getProperty('pE4000','IntensityC'));
else
   I550 = '0';
end
if char(mmc.getProperty('pE4000','ChannelC')) == '580'
   I580 = char(mmc.getProperty('pE4000','IntensityC'));
else
   I580 = '0';
end
if char(mmc.getProperty('pE4000','ChannelC')) == '595'
   I595 = char(mmc.getProperty('pE4000','IntensityC'));
else
   I595 = '0';
end

if char(mmc.getProperty('pE4000','ChannelD')) == '635'
   I635 = char(mmc.getProperty('pE4000','IntensityD'));
else
   I635 = '0';
end

if char(mmc.getProperty('pE4000','ChannelD')) == '660'
   I660 = char(mmc.getProperty('pE4000','IntensityD'));
else
   I660 = '0';
end

if char(mmc.getProperty('pE4000','ChannelD')) == '740'
   I740 = char(mmc.getProperty('pE4000','IntensityD'));
else
   I740 = '0';
end

if char(mmc.getProperty('pE4000','ChannelD')) == '770'
   I770 = char(mmc.getProperty('pE4000','IntensityD'));
else
   I770 = '0';
end


output = 'Ch_365=%s Ch_385=%s Ch_405=%s Ch_435=%s Ch_460=%s Ch_470=%s Ch_490=%s Ch_500=%s Ch_525=%s Ch_550=%s Ch_580=%s Ch_595=%s Ch_635=%s Ch_660=%s Ch_740=%s Ch_770=%s';



TTLtrigger = char(varargin);

if isempty(TTLtrigger)
    if nargout == 0
        fprintf(output,I365,I385,I405,I435,I460,I470,I490,I500,I525,I550,I580,I595,I635,I660,I740,I770); 
        fprintf('\n');
    else
        varargout{1} = sprintf(output,I365,I385,I405,I435,I460,I470,I490,I500,I525,I550,I580,I595,I635,I660,I740,I770);
    end
else
    keySet =   {'AllFourTTL','ChATTL','ChBTTL','ChCTTL','ChDTTL','ChABTTL','ChBCTTL','ChABCTTL'};
    valueSet = {{I365,I385,I405,I435,I460,I470,I490,I500,I525,I550,I580,I595,I635,I660,I740,I770},{I365,I385,I405,I435},{I460,I470,I490,I500},{I525,I550,I580,I595},{I635,I660,I740,I770},{I365,I385,I405,I435,I460,I470,I490,I500},{I460,I470,I490,I500,I525,I550,I580,I595},{I365,I385,I405,I435,I460,I470,I490,I500,I525,I550,I580,I595}};
    mapChannelsIntensity = containers.Map(keySet,valueSet);
    if isKey(mapChannelsIntensity,TTLtrigger)
        valueSetNames = {{'I365_','I385_','I405_','I435_','I460_','I470_','I490_','I500_','I525_','I550_','I580_','I595_','I635_','I660_','I740_','I770_'},{'I365_','I385_','I405_','I435_'},{'I460_','I470_','I490_','I500_'},{'I525_','I550_','I580_','I595_'},{'I635_','I660_','I740_','I770_'},{'I365_','I385_','I405_','I435_','I460_','I470_','I490_','I500_'},{'I460_','I470_','I490_','I500_','I525_','I550_','I580_','I595_'},{'I365_','I385_','I405_','I435_','I460_','I470_','I490_','I500_','I525_','I550_','I580_','I595_'}};
        mapChannelsNames = containers.Map(keySet,valueSetNames);
        intensity = mapChannelsIntensity(TTLtrigger);
        names = mapChannelsNames(TTLtrigger);
        k = cellfun(@(x) strcmp(x,'0'),intensity);
        intensity(k == 1) = [];
        names(k == 1) = [];
        varargout{1} = cellfun(@(x,y)[x y],names,intensity,'uni',false);

        if isempty(varargout{1})
            varargout{1} = 'I_0';
        elseif numel(varargout{1}) > 1
            varargout{1} = join(varargout{1},'_');
        end
    else
        varargout{1} = '';
    end
end
end


