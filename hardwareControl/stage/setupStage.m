function [] = setupStage()
%SETUPSTAGE Summary of this function goes here
%   Detailed explanation goes here

global ti2;

ti2.XPositionSpeed.Value = 1.9;
ti2.XPositionTolerance.Value = 0; % um
ti2.YPositionSpeed.Value = 1.9;
ti2.YPositionTolerance.Value = 0; % um

end

