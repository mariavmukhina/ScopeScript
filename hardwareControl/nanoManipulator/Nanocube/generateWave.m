function [ ] = generateWave()
%generateWave defines the motion of NanoCube along z axis during pressure application based on the parameters defined in scopeParams
%function is called if the parameter 'generateWave' is added to function[i] definition
%generateWave sends instructions to Nanocube controller

global E727;

fcScope = scopeParams();
disp('starting the wave generation');
wType = fcScope.waveType;

try
    if contains(wType,'square')
        
        OffsetOfFirstPointInWaveTable = 0;
        NumberOfWavePointsRest = fcScope.restDuration/0.05; % convert msec to number of servo updates points, servo update time is 50 us
        NumberOfWavePointsPpulse = fcScope.PpulseDuration/0.05;
        NumberOfWavePointsDownUP = strainRate(fcScope.waveAmplitude,fcScope.strainRate); % points*50 us
        NumberOfSpeedUpDownPointsOfWave = 1;
        %AmplitudeOfWave = MPa_to_um(fcScope.waveAmplitude); % in um (physical units of Z axis of nanocube)
        AmplitudeOfWave = fcScope.waveAmplitude; % in um (physical units of Z axis of nanocube)
        OffsetOfWave = E727.qPOS('3');
        SegmentLength_Rest = NumberOfWavePointsRest+2*NumberOfSpeedUpDownPointsOfWave+OffsetOfFirstPointInWaveTable;
        SegmentLength_Ppulse = NumberOfWavePointsPpulse+2*NumberOfSpeedUpDownPointsOfWave+OffsetOfFirstPointInWaveTable;
        SegmentLengthDownUP = NumberOfWavePointsDownUP+2*NumberOfSpeedUpDownPointsOfWave+OffsetOfFirstPointInWaveTable;

        pointsPerPeriod = NumberOfWavePointsRest + NumberOfWavePointsPpulse + 2*NumberOfWavePointsDownUP + 8*NumberOfSpeedUpDownPointsOfWave;
        timeOfAquisition = ((fcScope.exposure10)/0.05)*fcScope.zStackZeroStep_N;
        NumberOfWavePeriods = round(timeOfAquisition/pointsPerPeriod)-2; %based on exposure for ML fcScope

        % generate 1 period of the wave
        %command format from PIGCS_2_0_DLL_SM151E270 (p122) 
        %BOOL PI_WAV_LIN (int ID, int iWaveTableId, int iOffsetOfFirstPointInWaveTable, int iNumberOfWavePoints, int iAppendWave, int iNumberOfSpeedUpDownPointsOfWave, double dAmplitudeOfWave, double dOffsetOfWave, int iSegmentLength)
        %ID ID of controller
        %iWaveTableId The ID of the wave table
        %iOffsetOfFirstPointInWaveTable The index of the starting point of the scan line in the segment. Lowest possible value is 0.
        %iNumberOfWavePoints The length of the single scan line curve as number of points.
        %iAppendWave Possible values (supported values depend on controller): 0 = clears the wave table and starts writing with the first point in the table 1 = adds the content of the defined segment to the already existing wave table contents (i.e. the values of the defined points are added to the existing values of that points) 2 = appends the defined segment to the already existing wave table content (i.e. concatenates segments to form one final waveform)
        %dAmplitudeOfWave The amplitude of the scan line.
        %iNumberOfSpeedUpDownPointsOfWave The number of points for speed up and down.
        %dOffsetOfWave The offset of the scan line
        %iSegmentLength The length of the wave table segment as number of points. Only the number of points given by iSegmentLength will be written to the wave table. If the iSegmentLength value is larger than the iNumberOPoints value, the missing points in the segment are filled up with the endpoint value of the curve.
        %compsession
        E727.WAV_LIN(1, OffsetOfFirstPointInWaveTable, NumberOfWavePointsRest, 0, NumberOfSpeedUpDownPointsOfWave, 0, OffsetOfWave, SegmentLength_Rest);
        E727.WAV_LIN(1, OffsetOfFirstPointInWaveTable, NumberOfWavePointsDownUP, 2, NumberOfSpeedUpDownPointsOfWave, (-1)*AmplitudeOfWave, OffsetOfWave, SegmentLengthDownUP);
        E727.WAV_LIN(1, OffsetOfFirstPointInWaveTable, NumberOfWavePointsPpulse, 2, NumberOfSpeedUpDownPointsOfWave, 0, OffsetOfWave-AmplitudeOfWave, SegmentLength_Ppulse);
        E727.WAV_LIN(1, OffsetOfFirstPointInWaveTable, NumberOfWavePointsDownUP, 2, NumberOfSpeedUpDownPointsOfWave, AmplitudeOfWave, OffsetOfWave-AmplitudeOfWave, SegmentLengthDownUP);
%         %dilation
%         E727.WAV_LIN(1, OffsetOfFirstPointInWaveTable, NumberOfWavePointsRest, 0, NumberOfSpeedUpDownPointsOfWave, 0, OffsetOfWave, SegmentLength_Rest);
%         E727.WAV_LIN(1, OffsetOfFirstPointInWaveTable, NumberOfWavePointsDownUP, 2, NumberOfSpeedUpDownPointsOfWave, AmplitudeOfWave, OffsetOfWave, SegmentLengthDownUP);
%         E727.WAV_LIN(1, OffsetOfFirstPointInWaveTable, NumberOfWavePointsPpulse, 2, NumberOfSpeedUpDownPointsOfWave, 0, OffsetOfWave+AmplitudeOfWave, SegmentLength_Ppulse);
%         E727.WAV_LIN(1, OffsetOfFirstPointInWaveTable, NumberOfWavePointsDownUP, 2, NumberOfSpeedUpDownPointsOfWave, (-1)*AmplitudeOfWave, OffsetOfWave+AmplitudeOfWave, SegmentLengthDownUP);
    
    elseif contains(wType,'ramp')
        
        OffsetOfFirstPointInWaveTable = fcScope.restDuration/0.05; % convert msec to number of servo updates points, servo update time is 50 us
        CenterPointOfWave = strainRate(fcScope.waveAmplitude,fcScope.strainRate/4); % points*50 us        
        NumberOfWavePointsDownUP = strainRate(fcScope.waveAmplitude,fcScope.strainRate); % points*50 us
        NumberOfSpeedUpDownPointsOfWave = 1;
        AmplitudeOfWave = MPa_to_um(fcScope.waveAmplitude); % in um (physical units of Z axis of nanocube)
        %AmplitudeOfWave = fcScope.waveAmplitude; % in um (physical units of Z axis of nanocube)
        OffsetOfWave = E727.qPOS('3');
        NumberOfWavePoints = CenterPointOfWave+NumberOfWavePointsDownUP;
        SegmentLength = OffsetOfFirstPointInWaveTable+CenterPointOfWave+NumberOfWavePointsDownUP+2*NumberOfSpeedUpDownPointsOfWave;
        timeOfAquisition = ((fcScope.exposure10)/0.05)*fcScope.zStackZeroStep_N;
        NumberOfWavePeriods = 1;%round(timeOfAquisition/SegmentLength); %based on exposure for ML fcScope

        % generate 1 period of the wave
        %command format from PIGCS_2_0_DLL_SM151E270 (p123) 
        %BOOL PI_WAV_RAMP (int ID, int iWaveTableId, int iOffsetOfFirstPointInWaveTable, int iNumberOfWavePoints, int iAppendWave, int iCenterPointOfWave, int iNumberOfSpeedUpDownPointsOfWave, double dAmplitudeOfWave, double dOffsetOfWave, int iSegmentLength)
        %ID ID of controller
        %iWaveTableId The ID of the wave table
        %iOffsetOfFirstPointInWaveTable The index of the starting point of the scan line in the segment. Lowest possible value is 0.
        %iNumberOfWavePoints The length of the single scan line curve as number of points.
        %iAppendWave Possible values (supported values depend on controller): 0 = clears the wave table and starts writing with the first point in the table 1 = adds the content of the defined segment to the already existing wave table contents (i.e. the values of the defined points are added to the existing values of that points) 2 = appends the defined segment to the already existing wave table content (i.e. concatenates segments to form one final waveform)
        %iCenterPointOfWave
        %iNumberOfSpeedUpDownPointsOfWave  The number of points for speed up and down.
        %dAmplitudeOfWave The amplitude of the scan line.
        %dOffsetOfWave The offset of the scan line
        %iSegmentLength The length of the wave table segment as number of points. Only the number of points given by iSegmentLength will be written to the wave table. If the iSegmentLength value is larger than the iNumberOPoints value, the missing points in the segment are filled up with the endpoint value of the curve.
        %compsession
        E727.WAV_RAMP(1, OffsetOfFirstPointInWaveTable, NumberOfWavePoints, 0, CenterPointOfWave, NumberOfSpeedUpDownPointsOfWave, (-1)*AmplitudeOfWave, OffsetOfWave, SegmentLength);
    end
    
    E727.WSL([3],1); % assign waveform #1 (first parameter of function WAV) to selected axes, 1- x, 2 - y, 3 - z
    E727.WGC([3],NumberOfWavePeriods); % set Number Of Wave Generator Cycles
    E727.WGO([3],1); % start wave generation immediately, first number indicates wave generator, second - start mode; to start simultaneously two wave generators use E727.WGO([3 1],[1 1]);

catch e %e is an MException struct
    fprintf(1, e.message);
    rethrow(e)
end
end

