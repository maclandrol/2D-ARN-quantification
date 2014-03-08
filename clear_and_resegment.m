function [cell, nuc]= clear_and_resegment(cell, nuc)
%% CLSEG(Cell, Nuc)
%Resegment, clear border and return a new image matrice
%cell and nuc are images matrix
%CLSEg is a private function

bwcell= im2bw(cell, 0);
bwcell=bwmorph(bwcell, 'spur',1);
bwcell=bwmorph(bwcell, 'Hbreak',1);
bwcell=imopen(bwcell, strel('square',5));
cell(bwcell==0)=0;
cell=imreconstruct(nuc, cell); %%%%This is important
cell= clearborder(cell);
background = mode(cell(:));
Intenpos = int64(unique(sort(cell(cell~=background))))'; % trouver le nombre de cellules et la liste des valeurs d'intensités
for i=Intenpos
    if nnz(cell==i)<=nnz(nuc==i)
        cell(cell==i)=background;
        nuc(nuc==i)=background;
    end
end
end
%------------------------------------------------------------------------%

function cell = clearborder(pCell)

[x1, y1]= size(pCell);

bord=unique(union(union(pCell(x1,:),pCell(1,:)), union(pCell(:,y1),pCell(:,1))));
cell=pCell;
cell(ismember(cell,bord))=0;

end