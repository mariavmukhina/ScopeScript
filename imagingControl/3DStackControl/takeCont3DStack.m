classdef takeCont3DStack < I_doExperiment
    %TAKECONT3DSTACK will program the arduino peizo controller and execute 
    %a continous stack specified by the argumentList
    % >> stack = takeCont3DStack({'zStack1','WhiteTTL',Nstacks});
    % this will invoke class scopeParams, and execute a stack specified by
    % zStack1, with WhiteTTL triggers.
    % >> stack = takeCon3DStack({'zStack1','WhiteTTL',Nstacks},'fcScope',fcScope);
    % this will do the same but with the provided fcScope
    %
    % The point of a continous stream is to take images in the same channel going up and
    % down the zstack to double the capture frequency, so only one zStack1
    % parameter set is defined, and this function will automatically
    % populate the opposite phase with the same TTLtrigger
    %
    % >> stack.plot
    % >> stack.save
    % >> stack.genMeta
    %
    % fchang@fas.harvard.edu
    
    properties
        currFcScope;
        output;
    end
    
    methods
        function obj = takeCont3DStack(argumentList,varargin)
            p = inputParser;
            p.addParameter('fcScope',[],@(x) true);
            p.parse(varargin{:});
            input           = p.Results;
            fcScope         = input.fcScope;
            
            if isempty(fcScope)
                fcScope = scopeParams;
            end
            obj.currFcScope = fcScope;
            setFunctionNameFolder('takeCont3DStack');
            obj.output = executeTakeCont3DStack(argumentList,fcScope);
            fprintf('\n\n');
        end
        
        function [] = plot(obj)
            
        end
    end
    
end

