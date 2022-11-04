function parsedAndValues = parseParamsForFunctions(fcScope)
%PARSEPARAMSFORFUNCTIONS given an fcScope, this function will parse it for
%its functions to execute
% parsed{1}{1} = function1
% parsed{1}{2} = setChannel1
% parsed{1}{3} = timepoints1
% 
% missing setChanneli and timePointsi are specified as 'none'

% find functionsi
parsed = regexp(properties(fcScope),'function[0-9]+','match');
parsed = removeEmptyCells(parsed);

% find setChanneli
for i = 1:numel(parsed)
    currFunc = parsed{i}{1};
    currChannel = regexprep(currFunc,'function','setChannel');
    currChannel = removeEmptyCells(regexp(properties(fcScope),[currChannel '$'],'match'));
    if numel(currChannel) == 1
        parsed{i}{2} = currChannel{1}{1};
    elseif numel(currChannel) == 0
        parsed{i}{2} = 'none';
    else
        error(['more than 1 setChannel specified for ' currFunc]);
    end
end
% find timepointsi
for i = 1:numel(parsed)
    currFunc = parsed{i}{1};
    currChannel = regexprep(currFunc,'function','timePoints');
    currChannel = removeEmptyCells(regexp(properties(fcScope),[currChannel '$'],'match'));
    if numel(currChannel) == 1
        parsed{i}{3} = currChannel{1}{1};
    elseif numel(currChannel) == 0
        parsed{i}{3} = 'none';
    else
        error(['more than 1 setChannel specified for ' currFunc]);
    end
end

% find exposurei
for i = 1:numel(parsed)
    currFunc = parsed{i}{1};
    currChannel = regexprep(currFunc,'function','exposure');
    currChannel = removeEmptyCells(regexp(properties(fcScope),[currChannel '$'],'match'));
    if numel(currChannel) == 1
        parsed{i}{4} = currChannel{1}{1};
    elseif numel(currChannel) == 0
        parsed{i}{4} = 'none';
    else
        error(['more than 1 setChannel specified for ' currFunc]);
    end
end

values = cell(size(parsed));
% get values
for j = 1:4
    for i = 1:numel(parsed)
        name = parsed{i}{j};
        if ~strcmp(name,'none')
            values{i}{j} = get(fcScope,name);
        else
            values{i}{j} = 'none';
        end
    end
end

parsedAndValues.parsed = parsed;
parsedAndValues.values = values;
parsedAndValues.pfsOffset = fcScope.pfsOffset;
parsedAndValues.stagePos = fcScope.stagePos;


end

