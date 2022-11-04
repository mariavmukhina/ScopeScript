function [Npoints] = strainRate(P,rate)
%given P amplitude (µm) and strain rate (µm/ms), returns the number of
%points for the Nanocube wave generator

T_resolution = 0.05; %ms temporal resolution of Nanocube controller
T_Papplication = P/rate; %ms
Npoints = T_Papplication/T_resolution;

end

