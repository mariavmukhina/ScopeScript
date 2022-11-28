function [] = fastStage()
%FASTSTAGE sets high speed of the XY microscope stage during the live acquisitions
%moving between XY positions during the Z stack acquisiton is done at lower speed defined by setupStage()

global ti2;

ti2.XPositionSpeed.Value = 19;
ti2.XPositionTolerance.Value = 0; % um
ti2.YPositionSpeed.Value = 19;
ti2.YPositionTolerance.Value = 0; % um
end

