function AnalysisOut(CorrFile, DistFile, FirstOut1, MergeOut1)

try
    out1= importdata(FirstOut1,'\t', 1);
    mergeout1= importdata(MergeOut1,'\t', 1);
    dist= importdata(DistFile,'\t', 1);
    corres= load(CorrFile);
catch err
    error('unable to read a file');
    disp(err);
end

%% G2 cell writing
G2cellpos= ~ismember(mergeout1.data(:,2),corres(:,2));
G2cell= zeros(nnz(G2cellpos), 7);
%Num cell|corrARNnuc|CorrARNCyto| NumTransSit|Site1|Site2|Coeff
%CellNum
G2cell(:,1)= mergeout1.data(G2cellpos, 1);
%Corr. ARNnuc
G2cell(:,2)= mergeout1.data(G2cellpos, 12);
%Corr. ARNCyto
G2cell(:,3)= mergeout1.data(G2cellpos, 11);
%# transcipt site
G2cell(:,4)=1;
G2cell((find(mergeout1.data(G2cellpos, 7).*mergeout1.data(G2cellpos, 8)~=0)),4)= 2;
G2cell((find((mergeout1.data(G2cellpos, 7)==0) & (mergeout1.data(G2cellpos, 8)==0))),4)= 0;
%# ARN site 1
G2cell(:,5)= mergeout1.data(G2cellpos, 7);
%# ARN site 2
G2cell(:,6)= mergeout1.data(G2cellpos, 8);
%Coeff( NucArea/CellArea)
G2cell(:,7)= mergeout1.data(G2cellpos, 10)./mergeout1.data(G2cellpos, 9);

fidg= fopen('G2.data', 'wt+');
G2cell=G2cell';
fprintf(fidg, '%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'Cell_number' , 'Cor. ARNnuc', 'Cor. ARNcyto', '# Trans. Site', 'ARN Tr. Site1', 'ARN Tr. Site2', 'Coeff(nArea/cArea)');
fprintf(fidg, '%d\t%d\t%d\t%d\t%d\t%d\t%f\n', G2cell);
fclose(fidg);
%% Late and early mitose
fide= fopen('EarlyM.data','wt+');
fidm= fopen('LateM.data','wt+');
fprintf(fidm, '%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'Cell_number' , 'Cor. ARNnuc', 'Cor. ARNcyto', '# Trans. Site', 'ARN Tr. Site1', 'ARN Tr. Site2', 'Coeff(d/e)');
fprintf(fide, '%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'Cell_number' , 'Cor. ARNnuc', 'Cor. ARNcyto', '# Trans. Site', 'ARN Tr. Site1', 'ARN Tr. Site2', 'Coeff(d/e)');
l=(size(corres,1)/2);
for i=1:l
    if(corres(i,3)==1)
        fid=fide;
    else
        fid=fidm;
    end
    Mcell= zeros(2,7);
    num = mergeout1.data(mergeout1.data(:,2)==corres(i,2),1);
    fprintf(fid, '%s\n', ['Cell_Num: ', num2str(num)]);
    Mcellpos= ismember(out1.data(:,2),corres([i i+l],2));
    %Num cell|corrARNnuc|CorrARNCyto| NumTransSit|Site1|Site2|Coeff
    %CellNum
    Mcell(:,1)= out1.data(Mcellpos, 1);
    %Corr. ARNnuc
    Mcell(:,2)= out1.data(Mcellpos, 12);
    %Corr. ARNCyto
    Mcell(:,3)= out1.data(Mcellpos, 11);
    %# transcipt site
    Mcell(:,4)=1;
    Mcell((find(out1.data(Mcellpos, 7).*out1.data(Mcellpos, 8)~=0)),4)= 2;
    Mcell((find(out1.data(Mcellpos, 7)==0 & out1.data(Mcellpos, 8)==0)),4)= 0;
    %# ARN site 1
    Mcell(:,5)= out1.data(Mcellpos, 7);
    %# ARN site 2
    Mcell(:,6)= out1.data(Mcellpos, 8);
    %Coeff d/e
    Mcell(:,7)= dist.data(dist.data(:,1)==num,13);
    Mcell=Mcell';
    fprintf(fid, '%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%f\n', Mcell(:));
    fprintf(fid, '\n');
end

fclose(fide);
fclose(fidm);
fclose('all');

