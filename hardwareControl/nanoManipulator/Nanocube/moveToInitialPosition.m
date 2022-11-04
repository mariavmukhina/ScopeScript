function [] = moveToInitialPosition(varargin)
%moves Nanocube to initial position, default is x = 50, y = 50, z = 100,
%otherwise parameters are read from scopeParams
if isempty(varargin)
    moveNanocubeZ(100);
    moveNanocubeX(50);
    moveNanocubeY(50);
elseif char(varargin{1}) == 'scopeParams'
    fcScope = scopeParams();
    moveNanocubeZ(fcScope.nanocubeZ);
    moveNanocubeX(fcScope.nanocubeX);
    moveNanocubeY(fcScope.nanocubeY);

end

