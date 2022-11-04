function [fileList,dxTrack] = getOrderedList(fileList,dx,mode)
%GETORDEREDLIST simply takes a list and orders it by dx, e.g _e[0-9]+
% mode is 'ascend' or 'descend'
dxMatch = regexp(fileList,['.*' dx],'match');
dxTrack = regexp( cellfun(@(x) x{1}, dxMatch,'UniformOutput',false),dx,'match');
dxTrack = cellfun(@(x) x{end}, dxTrack,'UniformOutput',false);
dxTrack = regexp(dxTrack,'[0-9]+$','match');
dxTrack = cellfun(@(x) x{end}, dxTrack,'UniformOutput',false);
dxTrack =  cellfun(@str2num,dxTrack);
dxMatch = cellfun(@(x) x{1}, dxMatch,'UniformOutput',false);

[~,index] = sort_nat(dxMatch,mode);
fileList = fileList(index);
dxTrack = dxTrack(index);
end

