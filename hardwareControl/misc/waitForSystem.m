function [] = waitForSystem()
%WAITFORSYSTEM 
global mmc;
try
mmc.waitForSystem();
catch
   warning('system took longer than 500ms'); 
end

end

