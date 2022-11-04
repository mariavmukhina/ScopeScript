function [] = setROI(roi)
%SETROI roi = [q_width,q_height,h_width,h_height];

global mmc;
mmc.setROI(roi(1), roi(2), roi(3), roi(4));

end

