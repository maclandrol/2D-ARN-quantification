function dist = centroid(Cell, Nuc)
%% Centroid(Cell, Nuc)
%Centroid find the center of the cell and its nucleus.
%It can also compute the distance between those center.
%Cell and Nuc are matrix
%Centroid is a private function.

Inten_List= int64(sort(unique(Cell(Cell>0))));
dist= double(zeros(size(Inten_List,1),5));
%variables quelconques pour la numérotation ultérieure des
%cellules(/noyaux)
xz=[];
xy=[];
yy=[];
yz=[];
if ~exist('diff.mat', 'file') % cas simple, sans merge, procédure facile.
    c_cen = zeros(1,2);
    n_cen = zeros(1,2);
    for i=1:size(Inten_List,1)
        %Trouver le centre de la cellule actuelle et du noyau correspondant
        bwCell= Cell==Inten_List(i); % transformation en image binaire
        bwNuc= Nuc==Inten_List(i);
        [x, y] = find(bwCell==1);
        k= size(x,1);
        c_cen = [sum(x)/k, sum(y)/k];
        [x, y] = find(bwNuc==1);
        k= size(x,1);
        n_cen = [sum(x)/k, sum(y)/k];
        dist(i,1:2)=c_cen;
        dist(i,3:4)=n_cen;
        %calcul de la distance
        dist(i,5)= sqrt((c_cen(1)-n_cen(1)).^2 + (c_cen(2)-n_cen(2)).^2);
        %        bwCell= mat2gray(im2double(bwCell));
        %        bwCell(uint16(c_cen(1)), uint16(c_cen(2)))=0.5;
        %        bwNuc= mat2gray(im2double(bwNuc));
        %        bwNuc(uint16(n_cen(1)), uint16(n_cen(2)))=0.5;
        %        h =figure(1);
        %        subplot(1,2,1), imshow(ind2rgb(gray2ind(bwCell,255),jet(255)));
        %        subplot(1,2,2), imshow(ind2rgb(gray2ind(bwNuc,255),jet(255)));
        %        pause();
    end
    
else
    load('diff.mat'); % Dans ce cas, l'appel vient de merge
    nuc_int_List= int64(unique(sort(nucdiff(nucdiff>0))));
    dist=[dist zeros(size(Inten_List,1),3)];
    mitose= zeros(size(Inten_List,1),1);
    c_cen = zeros(1,2);
    n_cen = zeros(1,4);
    %A lot of fancy stuff doing nothing really fancy.
    for i=1:size(Inten_List,1)
        bwCell= Cell==Inten_List(i);
        [x, y] = find(bwCell==1);
        k= size(x,1);
        c_cen = [sum(x)/k, sum(y)/k];
        dist(i,1:2)=c_cen;
    end
    for i=1:length(nuc_int_List)
        bwNuc= nucdiff==nuc_int_List(i);
        [x, y] = find(bwNuc==1);
        k= size(x,1);
        n_cen = [sum(x)/k, sum(y)/k];
        
        if(~ismember(i,cell_list(:,1:2)))
            [yz(end+1), yy(end+1)]=find(nucdiff==nuc_int_List(i),1);
            j= find(Inten_List==nuc_int_List(i));
            dist(j,3:4)=n_cen;
            dist(j,7)= sqrt((dist(j,1)-n_cen(1)).^2 + (dist(j,2)-n_cen(2)).^2);
            
        elseif(ismember(i,cell_list(:,1)))
            [yz(end+1), yy(end+1)]=find(nucdiff==nuc_int_List(i),1);
            j= find(Inten_List==nuc_int_List(i));
            %if(j<size(dist,1))
            dist(j,3:4)=n_cen;
            dist(j,7)= sqrt((dist(j,1)-n_cen(1)).^2 + (dist(j,2)-n_cen(2)).^2);
            mitose(j)= cell_list((cell_list(:,1)==i),3);
            %end
                        
        elseif(ismember(i,cell_list(:,2)))
            [xz(end+1), xy(end+1)]=find(nucdiff==nuc_int_List(i),1);
            j=cell_list(cell_list(:,2)==i,1);
            j=find(Inten_List==nuc_int_List(j));
            dist(j,5:6)=n_cen;
            dist(j,8)= sqrt((dist(j,1)-n_cen(1)).^2 + (dist(j,2)-n_cen(2)).^2);
            
        end
        
    end
    save('diff.mat','xz', 'xy', 'yy','yz','mitose', '-append');
    dist= axe2(Cell, Inten_List, dist); %par défaut axe selon extrémités
end

% numeroter les diff cellules et finaliser
dist = [double((1:size(dist,1)))' dist];

end


function dist = axe1(Cell, Inten_List, dist)
%Cette fonction trouve l'axe principale des cellules en utilisant la
%bibliotheque standard de MATLAB avec la fonction regionprops

d_e = zeros(size(dist,1),2);
stat= regionprops(Cell, 'MajorAxisLength');
stats= zeros(size(Inten_List,1),1);
for i=1:size(stat,1)
    stats(i,1)=stat(i).MajorAxisLength;
end
stats=stats(stats~=0);
stats= [stats stats];
for i=1:size(dist,1)
    if(dist(i,5)~=0 & dist(i,6)~=0 )
        d_e(i,1)= sqrt((dist(i,3)-dist(i,5)).^2 + (dist(i,4)-dist(i,6)).^2);
        d_e(i,2)= dist(i,7)+dist(i,8);
    end
end

dist = [ double(Inten_List) dist double(stats)  d_e./stats];
end


function dist = axe2(Cell, Inten_List, dist)
%Ceci est la fonction alternative utilisant les extrémités
d_e = zeros(size(dist,1),2);
stat = zeros(size(dist,1),2);
for i=1:size(Inten_List,1)
    bwCell= Cell==Inten_List(i);
    bwCell= bwperim(bwCell);
    [x,y]= find(bwCell~=0);
    inf_X = x(x<dist(i,1));
    inf_Y = y(x<dist(i,1));
    sup_X = x(x>dist(i,1));
    sup_Y = y(x>dist(i,1));
    inf.majvalue=0;
    inf.x=0;
    inf.y=0;
    sup.majvalue=0;
    sup.x=0;
    sup.y=0;
    for a=1:length(inf_X)
        d= sqrt((dist(i,1)-inf_X(a)).^2 + (dist(i,2)-inf_Y(a)).^2);
        if d> inf.majvalue
            inf.majvalue=d;
            inf.x= inf_X(a);
            inf.y= inf_Y(a);
        end
    end
    
    for a=1:length(sup_X)
        d= sqrt((dist(i,1)-sup_X(a)).^2 + (dist(i,2)-sup_Y(a)).^2);
        if d> sup.majvalue && ((inf.y>dist(i,2))~=(sup_Y(a)>dist(i,2)))
            sup.majvalue=d;
            sup.x= sup_X(a);
            sup.y= sup_Y(a);
        end
    end
%     figure, imshow(bwCell);
%     hold on;
%     plot(sup.y, sup.x, 'r-o', 'LineWidth',2);
%     plot(inf.y, inf.x,'g-*', 'LineWidth',2);
%     pause(); close();
    stat(i,2)= sup.majvalue +inf.majvalue;
    stat(i,1) = sqrt((sup.x-inf.x).^2 + (sup.y-inf.y).^2);
    for a=1:size(dist,1)
        if(dist(a,5)~=0 && dist(a,6)~=0 )
            d_e(a,1)= sqrt((dist(a,3)-dist(a,5)).^2 + (dist(a,4)-dist(a,6)).^2);
            d_e(a,2)= dist(a,7)+dist(a,8);
        end
    end
    
end
 
 dist = [ double(Inten_List) dist double(stat) d_e./stat];

end

