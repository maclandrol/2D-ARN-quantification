function mergeandquant(cell2merge, CellImg, NucImg, previous_output1, ARNfile, threshold, center)
%% MERGEANDQUANT(cell2merge, CellImg, NucImg, previous_output1, ARNfile, threshold, center).
% Merge the cell from cell2merge and then run ARN_quant.
% CellImg is the cell image filename; NucImg, the nucleus image
% filename,and ARNfile the ARNs localization file from Localize
% cell2merge is a tsv or csv format file and must be format like this :
% Cell1_id [tab/space/comma] Cell2_id.
% The cell id can be found in the output1 file
% previous_output1 is the output1 from th previous quantification using
% ARN_quant with the same data. 

[cellname, nucname, cell_list, path, corres] = mergecell(cell2merge, CellImg, NucImg, previous_output1);
nucdiff= imread(NucImg);
c=strcat(cell2merge(1:end-3),'corr');
dlmwrite(c, corres, '\t');

if exist('center', 'var')
    if(strcmp(center, 'on'))
        save ('diff.mat', 'nucdiff', 'cell_list', 'CellImg');
    end
    ARN_quant(cellname, nucname, ARNfile, threshold, center);
elseif exist('threshold', 'var')
    ARN_quant(cellname, nucname, ARNfile, threshold);
else
    ARN_quant(cellname, nucname, ARNfile);
end

if(strfind(CellImg, '.tiff'))
    num=CellImg(1:end-5);
else
    num= CellImg(1:end-4);
end
o=strcat(num,'_out1.txt');

if(strfind(cellname, '.tiff'))
    num=cellname(1:end-5);
else
    num= cellname(1:end-4);
end
m=strcat(num,'_out1.txt');
d=strcat(num, '.dist');
AnalysisOut(c,d,o,m);
delete(fullfile('diff.mat'));
%delete(fullfile(path(1:end-1), 'merge_*.txt'));
delete(fullfile( nucname), fullfile( cellname));
end