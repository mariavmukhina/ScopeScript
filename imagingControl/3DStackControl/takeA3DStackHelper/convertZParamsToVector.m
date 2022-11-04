function zVector = convertZParamsToVector(N,z0,dz)
%CONVERTZPARAMSTOVECTOR given parameters {N,z0,dz} return the full zVector

zVector = z0 + (0:(N-1))*dz;



end

