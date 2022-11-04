function [] = stopTimeLapse()

global masterFileMaker;
% clear timeLapse timer
t = timerfind('Name','timeLapse');
delete(t);
end

