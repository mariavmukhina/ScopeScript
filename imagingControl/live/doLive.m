function [] = doLive(oldROI,varargin)
%DOLIVE starts the stream from the camera and displays it in Matlab figure
% keyboard 'q' -> quits
% keyboard 'p' -> pauses
% keyboard 'e' -> executes function predefined in scopeParams; if
% {channel,energy} are provided as arguments, after the function execution, 
% scope returns to the PL hannel defined by these arguments
% keyboard 's' -> saves XY coordinates to stageCoordinates list
% keyboard '1-9' -> moves to position in stageCoordinates list


global showROI;

fastStage();
stopStreaming();

if scopeParams.sensorDefectCorrection
    sensorDefectCorrectON();
else
    sensorDefectCorrectOFF();
end
clearBuffer();
startStream();

if contains(iscaller(),'PL')
   holdPiezoPL();
else
   holdPiezoBF();
end

% state variables
quitLive = false;
pauseLive = false;
doExecute = false;
stage = false;
[st,~] = dbstack();
disp('[q:quit, p:pause, e:executeFunctions, s:save XY stage position, number:stagePos]');
   
doShow();
close(fig);

ttlPiezo();


function doShow()
        % n frames are needed to get the correct exposure
        temp = grabRecentFrame();
        while(isempty(temp))
            temp = grabRecentFrame();
        end
        fig = imtool(temp,[min(temp(:)), max(temp(:))]);
           set(fig,'units','normalized','outerposition',[0.05 0.15 0.43 0.81]);

        
        rectangle = int16(showROI);
        
        drawnow;
        set(fig,'KeyPressFcn',@keyDownListener);
        % get all axes in figure
        set(fig,'doublebuffer','on');
        iptsetpref('ImshowBorder','tight');
        iptsetpref('ImtoolInitialMagnification','adaptive');
        allAxesInFigure = findall(fig,'type','axes');
        set(allAxesInFigure, 'xlimmode','manual',...
            'ylimmode','manual',...
            'zlimmode','manual',...
            'climmode','manual',...
            'alimmode','manual');
        % get the children of axes
        imageHandle = get(allAxesInFigure,'Children');
        
        while ~quitLive
            temp = 0;
            while(temp == 0)
                views = grabRecentFrame();
                if ~isempty(views)
                    temp = 1;
                    shapeInserter = vision.ShapeInserter('BorderColor','Custom','LineWidth',3,'CustomBorderColor', max(views(:)));
                    views = step(shapeInserter, views, rectangle);
                end
            end
            
            if pauseLive
                stopStreaming();
                input('press enter key [in Command Window] to unpause','s');
                figure(fig);
                pauseLive = 0;
                startStream();
            else
                set(imageHandle,'CData',views);
                drawnow;
            end
            
            if doExecute
                stopStreaming();
                setROI(oldROI);
                
                executeFunctions();
                
                stopStreaming();
                clearBuffer();
                setROI(oldROI);
                if ~isempty(varargin)
                    setupChannel(varargin{1},varargin{2})
                end
                
                if strcmp(st(2).name,'liveBF')
                    fcScope = scopeParams;
                    setExposure(fcScope.cameraExposureLiveBF);
                    closeTurretShutter();
                    holdPiezoBF();
                else
                    fcScope = scopeParams;
                    setExposure(fcScope.cameraExposureLivePL);
                    openTurretShutter();
                    holdPiezoPL();
                end

                waitForSystem();
                figure(fig);
                doExecute = 0;
                startStream();
            end
            
            if stage
                stageAppend();
                stage = 0;
            end
            
        end
        stopStreaming();
end

function keyDownListener(src,event)
        switch event.Key
            case 'q'
                quitLive = true;
            case 'p'
                pauseLive = ~pauseLive;
                if pauseLive ==1
                    disp('paused');
                    commandwindow;
                else
                    disp('unpaused');
                end
            case 'e'
                doExecute = ~doExecute;
                if doExecute == 1
                    disp('executingFunction...');
                end
            case 's'
                stage = ~stage;
            otherwise
                if isstrprop(event.Key,'digit')
                    stageNum = str2double(event.Key);
                    stageGoTo(stageNum);
                end
        end
end

end

