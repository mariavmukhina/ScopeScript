function [] = exportSingleTifStack(filename,stack,varargin)
%EXPORTSINGLETIFSTACK will save a 3d stack as filename
% exportSingleTifStack('./file.tif',stack);
% exportSingleTifStack('./file.tif',stack,'description');
% will overwrite existing files
%
% fchang@fas.harvard.edu

% check stack type
if ~isa(stack,'uint16')
   warning('exportSingleTifStack(): stack that is not uint16');
end

saveParams = {'tif', 'Compression', 'none'};
[~,~,zL] = size(stack);

% check if filname has tif exentsion
[~,~,ext] =fileparts(filename);
if isempty(ext) || sum(strcmp(ext,{'.tif','.TIF'}))==0
   filename = [filename '.tif']; 
end
% check if filename exists
if ~exist(filename,'file')
    [~,~,~] = mkdir(returnFilePath(filename));
    display(['writing: ' filename ]);
    if isempty(varargin)
        for i = 1:zL
            imwrite(stack(:,:,i), filename ,saveParams{:}, 'WriteMode', 'append');
        end
    else
        description = varargin{1};
        for i = 1:zL
            imwrite(stack(:,:,i), filename ,saveParams{:}, 'WriteMode', 'append','Description',description);
        end
    end
else
    display(['overwriting: ' filename ]);
    delete(filename);
    if isempty(varargin)
        for i = 1:zL
            imwrite(stack(:,:,i), filename ,saveParams{:}, 'WriteMode', 'append');
        end
    else
        description = varargin{1};
        for i = 1:zL
            imwrite(stack(:,:,i), filename ,saveParams{:}, 'WriteMode', 'append','Description',description);
        end
    end 
end

