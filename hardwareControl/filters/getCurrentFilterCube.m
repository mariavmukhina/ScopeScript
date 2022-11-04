function filterCubeName = getCurrentFilterCube()
%GETCURRENTFILTERCUBE returns current filter cube name
global ti2;

i = get(ti2,'iTURRET1POS');
ti2Turret = ti2.Turret1Pos;
filterCubeName = strcat(num2str(i),'-',get(ti2Turret,'ShortName',i));
end

