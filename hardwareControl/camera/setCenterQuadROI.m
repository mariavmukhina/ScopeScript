function [] = setCenterQuadROI(varargin)
%SETCENTERQUADROI sets the center quadrant as the ROI for the camera, 
% by default it is set to half camera size
% user can also pass to the function specified width and length of the ROI

stopStreaming();
clearROI();
width = getWidthOfROI();
height = getHeightOfROI();

if nargin == 0
    h_width = round(width/2);
    h_height = round(height/2);
    
    q_width = round(h_width/2);
    q_height = round(h_height/2);
else
    input = varargin{1};
    h_width = input(1);
    h_height = input(2);
    q_width = round((width - h_width)/2);
    q_height = round((height - h_height)/2);
end
setROI([q_width,q_height,h_width,h_height]);
width = getWidthOfROI();
height = getHeightOfROI();
display(['ROI is set to ' num2str(width) 'x' num2str(height)]);

end

