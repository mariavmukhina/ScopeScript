function valOut=iscaller(varargin)
%ISCALLER Determine caller function.
stack=dbstack;
%stack(1).name is this function
%stack(2).name is the called function
%stack(3).name is the caller function
if length(stack)>=3
    callerFunction=stack(3).name;
else
    callerFunction='';
end
if nargin==0
    valOut=callerFunction;
elseif iscellstr(varargin)
    valOut=ismember(callerFunction,varargin);
else
    error('All input arguments must be a string.')
end    
end

