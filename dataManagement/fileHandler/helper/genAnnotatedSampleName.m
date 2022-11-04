function annotatedName = genAnnotatedSampleName(varargin)
%GENANNOTATEDSTRAINNAME generates a name that indicates its various
%parameters

p = inputParser;
p.addRequired('fcScope',@isobject);
p.addParameter('timePoint',[],@(x) true);
p.addParameter('stagePos',[],@(x) true);
p.addParameter('isBF',false,@(x) true);
p.addParameter('channel',[],@(x) true);
p.addParameter('TTLchannel',[],@(x) true);
p.addParameter('LEDlevels',[],@(x) true);

p.parse(varargin{:});
input  = p.Results;
fcScope = input.fcScope;
timepoint = input.timePoint;
stagepos = input.stagePos;
isbf = input.isBF;
channel = input.channel;
TTLchannel = input.TTLchannel;
LEDlevels = input.LEDlevels;
if isbf
    if ~isempty(channel)
        channel = ['_bf' channel];
    end
else
    if ~isempty(channel)
        if ~isempty(TTLchannel)
            if iscell(TTLchannel)
               TTLchannel = insertAStringBetweenCells(',',TTLchannel); 
            end
            channel = ['_f' channel '(' TTLchannel ')'];
        else
            channel = ['_f' channel ];
        end
        
        if ~isempty(LEDlevels)
            channel = [channel '_' LEDlevels];
        end
        
    end
end

if ~isempty(timepoint)
    timepoint = ['_t' num2str(timepoint)];
end

if ~isempty(stagepos)
    stagepos = ['_s' num2str(stagepos)];
end

strainName = fcScope.defaultSampleName;

annotatedName = [strainName channel stagepos timepoint];
    

end

