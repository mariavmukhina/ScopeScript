function objectiveName = getCurrentObjective()
%GETCURRENTFILTERCUBE returns current filter cube name
global ti2;

i = get(ti2,'iNOSEPIECE');
ti2Nosepiece = ti2.Nosepiece;
objectiveName = strcat(num2str(i),'-',get(ti2Nosepiece,'LongName',i));
end

