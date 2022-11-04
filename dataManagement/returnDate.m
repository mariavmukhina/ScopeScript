function [today] = returnDate()
%RETURNDATE returns todays date in 20130809 format
% 
temp = datevec(date);
year = temp(1);
month = temp(2);
day = temp(3);

today = sprintf('%d%02d%02d',year,month,day);

end

