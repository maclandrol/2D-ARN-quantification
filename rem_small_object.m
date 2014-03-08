function rem_small_object(Cellimage, Nucimage, seuil, ARNfile, threshold, center)
%% rem_small_object(Cellimage, Nucimage, seuil, ARNfile, threshold, center)
% Remove the smallest cells (and their nucleus). The smallest cells are
% those which are is lower than the threshold. This threshold is the input
% argument seuil

cell= imread(Cellimage); nuc= imread(Nucimage);
bwnuc = im2bw(nuc,0);
bwnuc2= bwareaopen(bwnuc, seuil);
diff= bwnuc~=bwnuc2;
intenlist= sort(unique(nuc(diff)));
nuc(ismember(nuc, intenlist))=0;
cell(ismember(cell,intenlist))=0;
imwrite(cell, strcat('rem_',Cellimage));
imwrite(nuc, strcat('rem_',Nucimage));

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
