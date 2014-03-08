function [cellname, nucname, cell_list, path, corres] = mergecell(cell2merge, cellImage, nucImage, output1)
%Mergecell(cell2merge, cellimage, nucimage, output1), merge les couples de
%cellules spécifiés dans cell2merge ( format de données csv, tsv ...) en
%fonction de leur numérotation dans output1.

cell_list=load(cell2merge);
cell = imread(cellImage);
nuc = imread(nucImage);
corres= zeros(size(cell_list,1),4);
try
    Intenpos= importdata(output1,'\t', 1);
catch err
    error('unable to read that file');
end

for i=1:size(cell_list,1)
    mark1= Intenpos.data(cell_list(i,1),2);
    mark2= Intenpos.data(cell_list(i,2),2);
    corres(i,1:2)=[cell_list(i,1), mark1];
    corres(i,3:4)= [cell_list(i,2), mark2];
    cell(cell==mark2)=mark1;
    nuc(nuc==mark2)=mark1;
    
end

corres= [corres(:,1:2) cell_list(:,3) ;corres(:,3:4) cell_list(:,3)];
num= strfind(cellImage,'/');
if(isempty(num)), num=strfind(cellImage,'\'); end 
num=num(end); %important de considerer uniquement le dernier dossier
path=cellImage(1:num);
cellname= strcat(cellImage(1:num),'merge_',cellImage(num+1:end));
nucname= strcat(nucImage(1:num),'merge_',nucImage(num+1:end));
imwrite(cell,cellname, 'tiff');
imwrite(nuc, nucname, 'tiff');
end
