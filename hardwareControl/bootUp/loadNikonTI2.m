function [] = loadNikonTI2()
%loadNikonTI2 creates Nikon's COM object

% at the first run, register Ti2 ActiveX control in Windows 
%cd 'C:\Program Files\Nikon\Ti2-SDK\bin';           
%!regsvr32 /s NkTi2Ax.dll;

global ti2;
ti2 = actxserver('Nikon.Ti2.AutoConnectMicroscope');
disp('loading Nikon Ti2 configuration ...');

end

