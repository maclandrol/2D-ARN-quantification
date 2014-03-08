function shuffle(liste,nf,varargin)

%Shuffle les nombres d'ARN de chaque expériences pour avoir une
%distribution random.
%Shuffle(Liste, num_exp, Output1, Output2, ...)
%Liste est la liste des cellules sélectionnées pour l'expérience num_exp
%Si aucune Liste ou num_exp, la commande doit être : Shuffle([], [], Output1, Output2, ...)
%Les output désignent la liste des out1 de chaque expérience pour laquelle
%le shuffle doit être exécuté.
suc=0;
if (~(~exist('liste', 'var') || isempty(liste) || ~exist('nf', 'var') || isempty(nf)))
    suc=1;list=load(liste);
end

Cell={};
for i = 1:length(varargin)
    try
       Cell{i}= importdata(varargin{i},'\t', 1);
    catch err
        error('unable to read your file');
    end
end

   
for i=1:length(varargin)
    M= Cell{i}.data;
    M=[M, zeros(size(M,1),2)];
    for j=1:size(M,1)
        if(trueOrFalse())
            M(j,end-1)=M(j,7);
            M(j,end)=M(j,8);
        else
            M(j,end-1)=M(j,8);
            M(j,end)=M(j,7);
        end
  
    end
    if(suc && i==nf)
         M= M(list,:);
    end
    header=Cell{i}.textdata;
    header{end+1}='Rand_Allele_1';
    header{end+1}='Rand_Allele_2';
    fid = fopen(strcat(num2str(i),'file.txt'), 'w');
    if fid == -1; error('Cannot open file: %s', outfile); end
    fprintf(fid, '%s\t', header{:});
    fprintf(fid, '\n');
    fclose(fid);
	dlmwrite(strcat(num2str(i),'file.txt'), M,'delimiter', '\t','-append');
end
end


function x = trueOrFalse()

x=0;
y= logical(int8(rand(2,1)));
    while(~xor(y(1),y(2)))
        y= logical(int8(rand(2,1)));
    end
    
    if(y(1))
        x=1;
    end
end