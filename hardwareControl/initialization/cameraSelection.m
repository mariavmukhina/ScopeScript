function [answer] = cameraSelection()
%cameraSelection allows user to choose between
%Hamamatsu Flash and Andor iXon cameras

title = 'Select one of the available cameras:';
prompt = {'1 - sCMOS Hamamatsu Flash; 2 - EMCCD Andor iXon;'};
answer = inputdlg(prompt,title);

end

