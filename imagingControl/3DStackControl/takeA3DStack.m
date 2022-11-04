classdef takeA3DStack < I_doExperiment
    %TAKEA3DSTACK will program the arduino peizo controller and execute a
    %stack specified by the argumentList
    % >> stack = takeA3DStack({'zStack1','WhiteTTL'});
    % this will invoke scopeParams, and execute a stack specified by
    % zStack1, with WhiteTTL triggers.
    % >> stack = takeA3DStack({'zStack1','WhiteTTL'},'fcScope',fcScope);
    % this will do the same but with the provided fcScope
    %
    % to execute several stacks in a single stream, argumentList consists:
    % 1) wavelength1 going up, then wavelenght2 going down
    %    {'zStack1','WhiteTTL','zStack2','BrightFieldTTL'}
    % 2) double wavelength going up, single wavelength going down
    %    {{'zStack1','zStack1'},{'GreenTTL','CyanTTL'},'zStack2','BrightFieldTTL'}
    % 3) double wavelength going up
    %    {{'zStack1','zStack1'},{'GreenTTL','CyanTTL'}}
    %
    % >> stack.save
    % >> stack.genMeta
    %
    % fchang@fas.harvard.edu
    
    properties
        zCommandOutput
        currFcScope
    end
    
    methods
        function obj = takeA3DStack(argumentList,varargin)
            p = inputParser;
            p.addParameter('fcScope',[],@(x) true);
            p.parse(varargin{:});
            input           = p.Results;
            fcScope         = input.fcScope;
            
            if isempty(fcScope)
                fcScope = scopeParams;
            end
            obj.currFcScope = fcScope;
            setFunctionNameFolder('takeA3DStack');
            [obj.zCommandOutput] = executeTakeA3DStack(argumentList,fcScope);
            
            fprintf('\n\n');
        end
        
        function [] = plot(obj)

        end
        
    end
    

end

