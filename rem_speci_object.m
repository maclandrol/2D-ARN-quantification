function rem_speci_object(CellImg, NucImg, remList, previous_out1, ARNfile, threshold, center)
%% rem_speci_object(CellImg, NucImg, remList, out1, ARNfile, threshold, center)
% Remove specifique cell and their nucleus using the cells ids and run
% ARN_quant on the new data if there aremore than 7 arguments.
% ARNfile, threshold, center are not mandatories
% remList is a file which contains the ids of cell to remove.
% Use  with precaution since it overwrite the  image and cell file.
% Assuming that the most frequent element is the background, which can be false
Cell= imread(CellImg);
Nuc= imread(NucImg);

largest = mode(Cell(:));
rem= load(remList);
intensx= importdata(previous_out1,'\t', 1);
intens=intensx.data;

for i=1:length(rem)
    Cell(Cell==(intens(rem(i),2)))=largest;
    Nuc(Nuc==(intens(rem(i),2)))=largest;
end
imwrite(Cell, CellImg);
imwrite(Nuc, NucImg);

if exist('ARNfile', 'var')
    if ~exist('threshold', 'var')
        threshold =0;
    end
    if ~exist('center', 'var')
        center='off';
    end
    ARN_quant(CellImg, NucImg, ARNfile, threshold,center,'on');
end
end
