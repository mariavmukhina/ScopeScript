function offset = getPFSOffset()
%GETPFSOFFSET if PFS is on, then the offset is reported, otherwise an empty
%vector is returned;

global ti2;
if ~isempty(ti2)
    if get(ti2,'iPFS_STATUS') == 778
        offset = ti2.iPFS_OFFSET;
    else
        offset = [];
    end
else
   offset = []; 
end
end

