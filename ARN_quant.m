function ARN_quant(CellImg, NucImg, ARNfile, threshold, center, filter, clseg)
%% ARN_quant(CellImg, NucImg, ARNfile, threshold, center, filtre, clseg)
%ARN_quant, quantification of ARNm using their position and intensity from
%Localize and the cell and nucleus segmentation from CellProfiler.
%CellImg, NucImg and ARNfile are the only mandatory arguments
%CellImg and NucImg can be filenames or matrix representation of the cell and nucleus images.
%Use center if you want to compute the centroid and distance between Nuc
% and Cell
%Center and filter are 'on'/'off' arguments
%By default center is 'off' and filter is 'on'
%Threshold is used to remove spots whose intensities are too low and
%therefore might make inaccurate the average intensities of cytoplasmic
%spots. Threshold is a number.
%clseg is the clear and smooth parameters, by default it's false

%% Verifier si le nombre d'argument est correct et mettre les valeurs par défaut dans le cas contraire.
narginchk(3,7);
if ~exist('filter', 'var') || isempty(filter)
    filter = 'on';
end

if ~exist('center', 'var') || isempty(center)
    center= 'off';
end

if ~exist('threshold', 'var') || isempty(threshold)
    threshold=-1;
end

if ~exist('clseg', 'var') || isempty(clseg)
    clseg = 'off';
end


%% Trouver le marqueur qui servira à distinguer l'output de l'exp actuelle
%des autres
if(strfind(CellImg, '.tiff'))
    num=CellImg(1:end-5);
else
    num= CellImg(1:end-4);
end

%% Lecture des images et du fichiers de localisation des ARNm
if(ischar(CellImg) && ischar(NucImg))
    cell = imread(CellImg); nuc =imread(NucImg); % lecture des images
else
    cell= CellImg; nuc=NucImg;
end
ARN= int64(load (ARNfile));  % load le fichier ARN avec les localisations
ARN=ARN((ARN(:,3)>=threshold),:);

Intenpos = int64(unique(sort(cell(cell>=0)))); % trouver le nombre de cellules et la liste des valeurs d'intensités
Nucleuspos = int64(unique(sort(nuc(nuc >=0)))); % trouver le nombre de noyaux

%% Essayer de corriger les petites erreurs de Cell-profiler (Erreurs de distribution et de segmentation)
%This can also be done by largest= mode(Cell); anyway, i'm really lazy to
%change it.
largest.name=0;
largest.value=-1;
for i=1:length(Intenpos)
    if(length(find(cell==Intenpos(i,1)))>largest.value)
        largest.value= length(find(cell==Intenpos(i,1)));
        largest.name=Intenpos(i,1);
    end
end


% Le pixel le plus fréquent est forcément le background !! Des tests ont
% montré que ce pixel n'était pas forcément celui avec 0 comme intensité
nuc(nuc==largest.name)=0;
cell(cell==largest.name)=0;

if(strcmp(clseg,'on'))
    [cell, nuc]= clear_and_resegment(cell, nuc); %this is perhaps important but for merge, don't
    imwrite(cell,CellImg);
    imwrite(nuc, NucImg);
end
%even think about it 'coz it fucks everything.

Intenpos = int64(unique(sort(cell(cell>0)))); % trouver le nombre de cellules et la liste des valeurs d'intensités
Nucleuspos = int64(unique(sort(nuc(nuc >0)))); %trouver le nombre de noyaux

%Corriger les problèmes au niveau de la différence de nombre entre cellule
%et noyaux
if(length(Intenpos)~=length(Nucleuspos))
    mauv_liste1=setdiff(Intenpos,Nucleuspos);
    mauv_liste2=setdiff(Nucleuspos,Intenpos);
    nuc(ismember(int64(nuc),mauv_liste2))=0;
    cell(ismember(int64(cell),mauv_liste1))=0;
    Intenpos = int64(unique(sort(cell(cell>0)))); % trouver le nombre de cellules et la liste des valeurs d'intensités
    Nucleuspos = int64(unique(sort(nuc(nuc >0)))); %trouver le nombre de noyaux
    
end

%% Assignation de chaque pixel aux noyaux, aux cellules ou aux background
nucgray= nuc; cellgray = cell;
cellgray=mat2gray(cell); nucgray=mat2gray(nuc);% aucune raison de le faire
nucgray(nucgray==0)=Inf; cellgray(cellgray==0)=Inf; % mettre les pixels à zero à l'infini (background)
matrice = cellgray./nucgray; % trouver les regions appartenant à chaque noyau pour chaque cellule
%infini/infini = NaN pour background
%x/x =1 pour noyau && cell
%x/infini = 0 pour cell et non noyau.
% cas non-testé : noyau et non cellule, donne : infini/x = infini, donc assigné au bacground.

%% Ajouter les spots et différencier spots cytoplasmiques de spots Nucléaires
if(length(Intenpos)==length(Nucleuspos)) % toutes les cellules trouvé ont egalement leur noyau trouvé
    matrice(isnan(matrice))=Inf; % infini designe le background alors
    im=matrice;
    % image quelconque pour print et voir progression.
    im2=im2bw(matrice, graythresh(matrice));
    im2=bwperim(im2);
    
    im(matrice==Inf)=0.22;
    %im(find(matrice==0))=0;
    im(matrice==1)=0.40;
    Intenpos=[Intenpos,zeros(length(Intenpos),1),zeros(length(Intenpos),1)];%  CellLabel | SpotCyto| SpotNuc
    nullARN=zeros(length(ARN(:,2)),1);
    nucARN=zeros(length(ARN(:,2)),1);
    cellARN=zeros(length(ARN(:,2)),1);
    for i=1:length(ARN(:,2))
        im(ARN(i,2), ARN(i,1))=0.61; % Trouver des ARN, et mettre des couleurs différentes.
        %im2(ARN(i,2), ARN(i,1))=1;
        which_cell(i)=cell(ARN(i,2), ARN(i,1));
        %Prendre la valeur de la position et l'ajouter à la liste des ARN avec cette valeur. : Cell | SpotCyto| SpotNuc
        m=matrice(ARN(i,2), ARN(i,1));
        A=matrice(ARN(i,2)-1:ARN(i,2)+1, ARN(i,1)-1:ARN(i,1)+1);
        if(m~=inf)
            nucARN(i)=(m == 1); % Liste des ARN nucléaires
            cellARN(i)= (m == 0); %Liste des ARN cytoplasmiques
            if(strcmp(filter,'on') && cellARN(i)==1 && sum(sum(A))~=inf && sum(sum(A))>0 && ((Intenpos(Intenpos(:,1)==which_cell(i), 3)<2) || (ARN(i,3)/mean(ARN((find(cellARN==1)),3))>1)))
                cellARN(i) =0;
                nucARN(i)=1;
                m=1;
            end
            
            y=Intenpos(Intenpos(:,1)==which_cell(i), m+2);
            Intenpos(Intenpos(:,1)==which_cell(i), m+2) = y+1;
            
            
        else
            % eventuel cas ou il y a des pixels environnants qui sont des ARNms,
            A(A==inf)=-1;
            if(sum(sum(A))==-9)
                nullARN(i)=1;
                % Vérifier si même intensité que la moyenne des intensités cytoplasmiques.
            elseif(mean(ARN((find(cellARN==1)),3))/ARN(i,3)==1)
                cellARN(i)=1;
                B= cell(ARN(i,2)-1:ARN(i,2)+1, ARN(i,1)-1:ARN(i,1)+1);
                B= B(A~=-1);
                which_cell(i)= mode(B);
                y=Intenpos(Intenpos(:,1)==which_cell(i), 2);
                Intenpos(Intenpos(:,1)==which_cell(i), 2) = y+1;
            end
            
        end
        
    end
    % ARN : x|y|intensity|isNucARN|isCellARN|whichCell (using Intensity to distinct cell and 0 == background)
    ARN(:,4)=nucARN;
    ARN(:,5)=cellARN;
    ARN(:,6)=which_cell;
    if ~exist('diff.mat','file')
        fprintf('ARN nucleaire total: %d et ARN cytoplasmique total: %d\n', sum(nucARN),sum(cellARN));
    end
    
    %im2=imclearborder(im2);
    %im2=bwlabeln(im2);
    %imshow(label2rgb(im2, @jet, [.5 .5 .5]));
    
    doStat(ARN, im, Intenpos, cell, nuc, num, center);
    
    
else
    fprintf('Mauvaise segmentation, noyaux sans cellules\n'); %Mauvaise segmentation (debug)
    
end
end


function doStat(X, im, Intenpos, cell, nuc,  num, center)
%% Dostat(X, im, Intenpos, cell, nuc, num, center)
%private function for computing stat on the data and writing outputs.

temp= X(:,5)==1;
cellIntensity=X(temp,3); % intensité des ARN cytoplasmiques
moy = mean(cellIntensity); % moyenne de ces intensitées
coeff = X(:,3)/ moy; %Liste des coefficient par rapport à cette moyenne pour tous les ARNm
X(:,7) = zeros(size(coeff)); % ajouter une colonne pour ces coefficients
X((find(X(:,4)==1)),7) = coeff(X(:,4)==1) >1; %  liste des sites de transcriptions potentiels. Colone 4, c'est les noyaux


Intenpos=[Intenpos, zeros(size(Intenpos,1),9)]; %Cell | SpotCyto| SpotNuc | maxTransc| secondMaxTrans |numberPixelCell|...Noyau | cor.CytoSpot

for a=1:size(Intenpos,1)
    
    potentiel_trans = sort(X((X(:,7)==1) &(X(:,6)==Intenpos(a,1)),3), 'descend'); % it works, don't try to understand.
    potentiel_trans_corrected = sort(X((X(:,4)==1) &(X(:,6)==Intenpos(a,1)),3), 'descend');
    Intenpos(a,8)=length(find(cell==Intenpos(a,1)));
    Intenpos(a,9)=length(find(nuc==Intenpos(a,1)));
    
    k=0;
    switch( length(potentiel_trans))
        case 0
            switch(length(potentiel_trans_corrected))
                case 0
                case 1
                    Intenpos(a,4)=potentiel_trans_corrected(1);
                    k=1;
                otherwise
                    Intenpos(a,4)=potentiel_trans_corrected(1);
                    Intenpos(a,5)=potentiel_trans_corrected(2);
                    k=2;
            end
            
        case 1
            Intenpos(a,4)=potentiel_trans(1);
            k=1;
            switch(length(potentiel_trans_corrected))
                case 0
                case 1
                otherwise
                    Intenpos(a,5)=potentiel_trans_corrected(2);
                    k=2;
            end
        case 2
            Intenpos(a,4)=potentiel_trans(1);
            Intenpos(a,5)=potentiel_trans(2);
            k=2;
        otherwise
            Intenpos(a,4)=potentiel_trans(1);
            Intenpos(a,5)=potentiel_trans(2);
            k=2;
    end
    Intenpos(a,10)=Intenpos(a,2)+Intenpos(a,3)-k;
    x= find(X(:,6)==Intenpos(a,1) & (X(:,3)==Intenpos(a,4)) & X(:,4));
    y= find(X(:,6)==Intenpos(a,1) & (X(:,3)==Intenpos(a,5)) & X(:,4));
    x1 = X(x,1); y1= X(x,2);
    x2 = X(y,1); y2= X(y,2);
    if((~isempty(x1) && ~isempty(x2) && ~isempty(y1) && ~isempty(y2)) && (length(x1)==length(x2)==length(y2)==length(y1)))
        d= sqrt(double((x1-x2).^2 +(y1-y2).^2));
        Intenpos(a,12) =d; %distance approximative en int au lieu de double
    end
end

%les cellules les plus petites ont les plus grands nombre d'ARN
%A= [double(Intenpos(:,2)+Intenpos(:,3)),double(Intenpos(:,12))];
%[A, A_index]= sort(A);
%A(:,1)=A(A_index(:,2),1);
%figure, plot(A(:,2),A(:,1) ,'-g.');

Intenpos(:,6)= Intenpos(:,4)/moy;
Intenpos(:,7)= Intenpos(:,5)/moy;
Intenpos(Intenpos(:,7)==0 &  Intenpos(:,5)>0,7)=1;
Intenpos(Intenpos(:,6)==0 & Intenpos(:,4)>0,6)=1;
Intenpos(:,11)= Intenpos(:,3)- (Intenpos(:,10)-Intenpos(:,2));
%CellNumber | Celllabel | SpotCyto| SpotNuc | maxTransc_localizer|
%secondMaxTrans_localizer |numberPixelCell|...Noyau | cor.CytoSpot | Cor.ARN_nuc

header={'Cell_No','Cell_Inten','ARN_cyto','ARN_nuc','1_max_Trans','2_max_Trans','1_num_Trans','2_num_Trans','Cell_area','Nuc_area','Cor.ARN_cyto', 'Cor.ARN_nuc','Dist_Trans'};
if(strcmp(center,'on'))
    dist=centroid(cell, nuc);
    header2={'Cell_num','Cell_Cent_x', 'Cell_Cent_y', 'Nuc_Cent_x','Nuc_Cent_y', 'Dist_center'};
    f = fopen(strcat(num,'.dist'), 'w');
    if f == -1; error('Cannot open file: %s', outfile); end
    if(exist('diff.mat', 'file'))
        load('diff.mat');
        [col, ind]= sort(mitose, 'ascend');
        dist= [dist(ind, :),col];
        header2={'Cell_num','Inten_list','Cell_Cent_x', 'Cell_Cent_y', 'Nuc1_Cent_x','Nuc1_Cent_y','Nuc2_Cent_x','Nuc2_Cent_y', 'Dist1_center','Dist1_center', 'Focal_axe(add)', 'Focal_axe(pyt)', 'd/e(add.)', 'd/e(pyt)','Mitosis'};
        fprintf(f, '%s\t', header2{:});
        fprintf(f, '\n');
        dlmwrite(strcat(num,'.dist'), dist,'delimiter', '\t','-append');
        fclose(f);
        
        for i=1:size(Intenpos,1)
            im(uint16(dist(i,3)), uint16(dist(i,4)))=0.90; %pour la cellule
            if(dist(i,5)~=0 && dist(i,6)~=0)
                im(uint16(dist(i,5)), uint16(dist(i,6)))=1;
            end
            if(size(dist,2)==14 && dist(i,8)~=0 && dist(i,7)~=0)
                im(uint16(dist(i,7)), uint16(dist(i,8)))=1;
            end
        end
        
    else
        fprintf(f, '%s\t', header2{:});
        fprintf(f, '\n');
        dlmwrite(strcat(num,'.dist'), dist,'delimiter', '\t','-append');
        fclose(f);
        for i=1:size(Intenpos,1)
            im(uint16(dist(i,2)), uint16(dist(i,3)))=0.90; %pour la cellule
            im(uint16(dist(i,4)), uint16(dist(i,5)))=1;
            
        end
        
        
    end
    
    
end

fid = fopen(strcat(num,'_out1.txt'), 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(strcat(num,'_out1.txt'), [(1:size(Intenpos,1))' Intenpos],'delimiter', '\t','-append');


%le code suivant sert a donner des poids aux pixels des sites de transcription.
a=0;
for a=1: length(coeff)
    
    if(X(a,7)==1)
        im(X(a,2)+1-coeff(a):X(a,2)+coeff(a)-1, X(a,1)+1-coeff(a):X(a,1)+coeff(a)-1) = 0.61;
    end
end


imwrite(ind2rgb(gray2ind(im,255),jet(255)), strcat(num,'_f.tiff'),'tiff');
X((find(X(:,7)==1)),7)= coeff(X(:,7)==1);%remplacer les sites de transcriptions, par leur coeff
% ARN : x|y|intensity|isNucARN|isCellARN|whichCell (using Intensity to distinct cell and 0 == background)
header={'x','y','intensity','is_ARN_nuc','is_ARN_cell','cell_Intensity','Trans_site_Coeff'};
fid = fopen(strcat(num,'_out2.txt'), 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(strcat(num,'_out2.txt'), X,'delimiter', '\t', '-append');
write_On_image(im, Intenpos(:,1), nuc, num);

%release all_data
%clear ; close all; clc
end

%% Ecrire les ids des cellules sur l'image
function write_On_image(im, towrite, nuc, num)
%ecrire sur l'image
f = figure('color','white','units','normalized','position',[.1 .1 .8 .8]);
imagesc(ind2rgb(gray2ind(im,255),jet(255)));
set(f,'units','pixels','position',[0 0 size(im,1)  size(im,2)],'visible','off')
%truesize; %this would be great but since it doesn't really work, fuck
%off
axis off


if(exist('diff.mat', 'file'))
    %merge, recuperer la numerotation des merges
    load('diff.mat');
    for l=1:length(xz)
        text('position',[xy(l) xz(l)], 'FontWeight','bold','fontsize',8,'string','0') ;
    end
    for l=1:length(yz)
        text('position',[yy(l) yz(l)], 'FontWeight','bold','fontsize',8,'string',int2str(l)) ;
    end
    
else
    %Cas ou il ne s'agit pas d'un merge, procédure normale.
    for a= 1:length(towrite)
        [i, j]=(find(nuc==towrite(a,1),1)); % pour retourner les coord x et  y
        h= text('position',[j i] , 'FontWeight','bold' ,'fontsize',10,'string',int2str(a)) ;
        
        
    end
end

% Capture the text image
% saveas(f, 'final_label', 'png');
X=getframe(gcf);
if isempty(X.colormap)
    imwrite(X.cdata,strcat(num,'_flabel.png'));
else
    imwrite(X.cdata,X.colormap,strcat(num,'_flabel.tiff'));
end
close(f);


end