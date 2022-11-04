function [interleavedChannel,interleavedEnergyParams] = genInterleavedChannels(zStackParamRoot,zStackEnergy,fcScope)
%GENINTERLEAVEDCHANNELS Summary of this function goes here
%   Detailed explanation goes here

if iscell(zStackParamRoot)
    interleavedChannel = cell(numel(zStackParamRoot),1);
    interleavedEnergyParams  = cell(numel(zStackParamRoot),1);
    for j = 1:numel(zStackParamRoot)
        interleavedChannel{j}.N  = get(fcScope,[zStackParamRoot{j} '_N']);
        interleavedChannel{j}.dz = get(fcScope,[zStackParamRoot{j} '_dz']);
        interleavedChannel{j}.z0 = get(fcScope,[zStackParamRoot{j} '_z0']);
        interleavedEnergyParams{j}.energyChannel = zStackEnergy{j};
    end
else
    interleavedChannel              = cell(1,1);
    interleavedEnergyParams         = cell(1,1);
    interleavedChannel{1}.N         =  get(fcScope,[zStackParamRoot '_N']);
    interleavedChannel{1}.dz        =  get(fcScope,[zStackParamRoot '_dz']);
    interleavedChannel{1}.z0        =  get(fcScope,[zStackParamRoot '_z0']);
    interleavedEnergyParams{1}.energyChannel = zStackEnergy;
end


