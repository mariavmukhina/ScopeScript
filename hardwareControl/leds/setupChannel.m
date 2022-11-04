function [] = setupChannel(varargin)
%SETUPCHANNEL sets the appropriate channel with the correct energyLevel
% setupChannel() lists all the channels available
% setupChannel('channel',energy) sets a channel with intensity[%] = energy; the channel can be either PL or BF
% setupChannel('channel',{energy1,energy2}) % sets a channel with multiple PL excitation bands

%% check if no argument, if so, just return avaialable filter cubes
if nargin == 0
    printAvailableFilterCubes();
    printAvailableBrightFieldChannels();
    return;
end

%% arguments
channel = varargin{1};
energy  = varargin{2};

%% setup channel
if contains(lower(channel),'brightfield')
    %% if the channel is brightfield, change the color abd turn on BF ttl trigger
    bfChannel = channel(1:strfind(lower(channel),'brightfield')-1);
    if contains(bfChannel,'00K')
    else        
    % make sure the first letter is capitalized
    bfChannel = lower(bfChannel);
    bfChannel = regexprep(bfChannel,'(\<\w)','${upper($1)}');
    end
    setBrightFieldTTL(bfChannel,energy);
    return;
else
    %% if the channel is fluorescent, execute filter cube change and update CoolLED parameters
    global mmc;
    currChannel = getCurrentFilterCube();
    fcScope = scopeParams();
    pauseTimeFilterCube = fcScope.pauseTimeFilterCube;

    % set BF illumination to zero
    setBrightFieldManual('4300K',0);

    %update CoolLED
    switch channel

        case {'1-QDot'}                                     % put here name of filter cube, names of all filter cubes can be listed by calling function printAvailableFilterCubes()
            mmc.setProperty('pE4000','IntensityA',energy);  % turn on selection of intensity for all active channels
            mmc.setProperty('pE4000','IntensityB',0);
            mmc.setProperty('pE4000','IntensityC',0);
            mmc.setProperty('pE4000','IntensityD',0);

            mmc.setProperty('pE4000','ChannelA',365);       % choose the wavelength for all active channels

            mmc.setProperty('pE4000','SelectionA',1);       % turn on all necessary channels

        case {'1-DAPI'}
            mmc.setProperty('pE4000','IntensityA',energy);
            mmc.setProperty('pE4000','IntensityB',0);
            mmc.setProperty('pE4000','IntensityC',0);
            mmc.setProperty('pE4000','IntensityD',0);

            mmc.setProperty('pE4000','ChannelA',385); 

            mmc.setProperty('pE4000','SelectionA',1);
        case {'2-mTeal'}
            mmc.setProperty('pE4000','IntensityA',energy);
            mmc.setProperty('pE4000','IntensityB',energy);
            mmc.setProperty('pE4000','IntensityC',0);
            mmc.setProperty('pE4000','IntensityD',0);

            mmc.setProperty('pE4000','ChannelA',435); 
            mmc.setProperty('pE4000','ChannelB',460); 

            mmc.setProperty('pE4000','SelectionA',1);
            mmc.setProperty('pE4000','SelectionB',1);
        case {'3-GFP'}
            mmc.setProperty('pE4000','IntensityA',0);
            mmc.setProperty('pE4000','IntensityB',energy);
            mmc.setProperty('pE4000','IntensityC',0);
            mmc.setProperty('pE4000','IntensityD',0);

            mmc.setProperty('pE4000','ChannelB',470); 

            mmc.setProperty('pE4000','SelectionB',1);
        case '4-mCherry'
            mmc.setProperty('pE4000','IntensityA',0);
            mmc.setProperty('pE4000','IntensityB',0);
            mmc.setProperty('pE4000','IntensityC',energy);
            mmc.setProperty('pE4000','IntensityD',0);

            mmc.setProperty('pE4000','ChannelC',550);

            mmc.setProperty('pE4000','SelectionC',1);
        case {'5-YFP'}
            mmc.setProperty('pE4000','IntensityA',0);
            mmc.setProperty('pE4000','IntensityB',energy);
            mmc.setProperty('pE4000','IntensityC',energy);
            mmc.setProperty('pE4000','IntensityD',0);

            mmc.setProperty('pE4000','ChannelB',500);
            mmc.setProperty('pE4000','ChannelC',525);

            mmc.setProperty('pE4000','SelectionB',1);
            mmc.setProperty('pE4000','SelectionC',1);
        case '6-CY5'
            mmc.setProperty('pE4000','IntensityA',0);
            mmc.setProperty('pE4000','IntensityB',0);
            mmc.setProperty('pE4000','IntensityC',0);
            mmc.setProperty('pE4000','IntensityD',energy); 

            mmc.setProperty('pE4000','ChannelD',635); 

            mmc.setProperty('pE4000','SelectionD',1);

        case '6-TRF561-640' % for Optosplit, simultaneous excitation with two bands
            if iscell(energy)
                energy1 = energy{1};
                energy2 = energy{2};
            else
                error('561-640 channel requires {energy1,energy2} in a cell array');
            end
            mmc.setProperty('pE4000','IntensityA',0);
            mmc.setProperty('pE4000','IntensityB',0);
            mmc.setProperty('pE4000','IntensityC',energy1);
            mmc.setProperty('pE4000','IntensityD',energy2); 

            mmc.setProperty('pE4000','ChannelC',550);
            mmc.setProperty('pE4000','ChannelD',635); 

            mmc.setProperty('pE4000','SelectionC',1);
            mmc.setProperty('pE4000','SelectionD',1);
            
        case {'2-redGr'}
            if iscell(energy)
                energy1 = energy{1};
                energy2 = energy{2};
            else
                error('redGreen channel requires {energy1,energy2} in a cell array');
            end

            mmc.setProperty('pE4000','IntensityA',0);
            mmc.setProperty('pE4000','IntensityB',energy1);
            mmc.setProperty('pE4000','IntensityC',energy2);
            mmc.setProperty('pE4000','IntensityD',0);


            mmc.setProperty('pE4000','ChannelB',470); 
            mmc.setProperty('pE4000','ChannelC',550); 

            mmc.setProperty('pE4000','SelectionB',1);
            mmc.setProperty('pE4000','SelectionC',1);
        otherwise
            error(['unknown channel:' channel]);
    end
    
    if ~strcmp(channel,currChannel)
        % execute fluorescent filter cube change
        setFilterCube(channel);
    
        disp(['pausing ' num2str(pauseTimeFilterCube) ' sec(s) to wait for vibrations to go down...']);
        pause(pauseTimeFilterCube);
        
        if iscell(energy)
            disp(['channel changed to ' channel ' with energy ' insertAStringBetweenCells(',',energy)]);
        else
            disp(['channel changed to ' channel ' with energy ' insertAStringBetweenCells(',',{energy})]);
        end
    end  
 end

end
