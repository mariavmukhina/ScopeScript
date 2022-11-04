function home = getHomeDir()
%GETHOMEDIR returns the home directory of the user

if ispc
    home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
else
    home = getenv('HOME');
end


end

