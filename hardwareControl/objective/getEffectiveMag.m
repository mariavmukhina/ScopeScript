function [curr_mag] = getEffectiveMag()
%GETEFFECTIVEMAG Summary of this function goes here
%   Detailed explanation goes here

global ti2;

% get current magnification
i = get(ti2,'iNOSEPIECE');
curr_objective = ti2.Nosepiece;
curr_mag = get(curr_objective,'LongName',i);
curr_mag = regexp(char(curr_mag),'[0-9]+x','match');
if isempty(curr_mag)
    curr_mag = {'60'};
end
curr_mag = curr_mag{1};
curr_mag = str2num(curr_mag(1:end-1));

% get current light path
curr_path = get(ti2,'iLIGHTPATH');
if strcmp(char(curr_path),'4')
    % left port cam 1x    
elseif strcmp(char(curr_path),'2')
    % right port cam 1x
    %curr_mag = curr_mag*2.5;   EM CCD used to have 2.5x c mount
else
    % other ports
end
end

