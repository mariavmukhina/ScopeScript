function currROI = getROI()
%GETROI Summary of this function goes here
%   Detailed explanation goes here

global mmc;
javaROI = mmc.getROI();
x = javaROI.getX;
y = javaROI.getY;
width = javaROI.getWidth;
height = javaROI.getHeight;
currROI = [x,y,width,height];

end

