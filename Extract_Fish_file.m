function Extract_Fish_file(FQfilename)
%% Extract_Fish_file(FQfilename)
% Extract information from the Fish_Quant output file
% FQfilename is the filename of Fishquant output

file =[];
try
    file = fopen(FQfilename);
catch e
    error(e);
end

line = fgets(file);
cell=0;
nuc=0;
Tx=0;
spot=0;
while ischar(line);
    if(strfind(line, 'CELL'))
        cell=cell+1;
        line1=fgets(file);
        line=fgets(file);
        data.cell{cell} = {line1,line};
    elseif(strfind(line, 'TxSite'))
        Tx=Tx+1;
        line1=fgets(file);
        line=fgets(file);
        data.Tx1{Tx} = {line1,line};
        line=fgets(file);
        if(strfind(line, 'TxSite'))
            line1=fgets(file);
            line=fgets(file);
            data.Tx2{Tx} = {line1,line};
        end
    elseif(strfind(line, 'Nucleus'))
        nuc=nuc+1;
        line1=fgets(file);
        line=fgets(file);
        data.nuc{nuc} = {line1,line};
    elseif(strfind(line, 'SPOTS'))
        spot=spot+1;
        line= fgets(file);
        if(strfind(line, 'Pos_Y'))
            data.header{spot}= line;
        end
        data.spot{spot} =[];
        line= fgets(file);
        while(ischar(line) && isempty(strfind(line, 'CELL')))
            data.spot{spot}=[data.spot{spot};str2num(line)];
            line= fgets(file);
        end
        
    else
        line= fgets(file);
    end
    
    
end
classify(data);
end

%%Reformat the data correctly
function classify(data)

len= [length(data.cell);length(data.nuc);length(data.Tx1);length(data.Tx2);length(data.header);length(data.spot)];
assert(sum(len==len(1))==length(len), 'Erreur dans data, données manquantes ou excédentaires');

for i=1:len(1)
    %reformat cell
    c1= data.cell{i}{1};
    c2 = data.cell{i}{2};
    c1=regexp(c1, '([0-9]+\s)+', 'match');
    c2=regexp(c2, '([0-9]+\s)+', 'match');
    data.cell{i}{1} =c1{1};
    data.cell{i}{2} =c2{1};
    
    %reformat nuc
    n1=data.nuc{i}{1};
    n2=data.nuc{i}{2};
    n1=regexp(n1, '([0-9]+\s)+', 'match');
    n2=regexp(n2, '([0-9]+\s)+', 'match');
    data.nuc{i}{1}=n1{1};
    data.nuc{i}{2} =n2{1};
    
    %reformat Tx1
    tx1=data.Tx1{i}{1};
    tx2=data.Tx1{i}{2};
    tx1=regexp(tx1, '([0-9]+\s)+', 'match');
    tx2=regexp(tx2, '([0-9]+\s)+', 'match');
    data.Tx1{i}{1}=tx1{1};
    data.Tx1{i}{2}=tx2{1};
    
    
    tx1=data.Tx2{i}{1};
    tx2=data.Tx2{i}{2};
    tx1=regexp(tx1, '([0-9]+\s)+', 'match');
    tx2=regexp(tx2, '([0-9]+\s)+', 'match');
    data.Tx1{i}{1}=tx1{1};
    data.Tx1{i}{2}=tx2{1};
end

save ('test.mat', 'data');
end


