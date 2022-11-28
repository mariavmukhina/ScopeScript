function [ ] = finishExperiment()
%finishExperiment is to be run at the end of an experiment to turn off all the LEDs

%holdPiezoBF keeps stage TTL constant, BF TTL constant, PL is TTL triggered
holdPiezoBF();
%set BF source (ScopeLED) to zero intensity and to manual control
setBrightFieldManual('4300K',0);
%sets all PL LEDs (CoolLED) to inactive state with zero intensities
turnOffAllEpiChannels();
end

