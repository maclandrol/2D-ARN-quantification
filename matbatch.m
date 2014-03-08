function matbatch(pathname, center,threshold)
%% Matbatch(pathname, center, threshold)
% Matbatch compute the batchmode of ARN_quant
% pathname is the directory name where all the files are. 
% Use the same number to denote all files from the same experience:
% Exp1 --->Cell1.tiff, Nuc1.tiff, XXX1.loc
% Exp2 --->Cell2.tiff, Nuc2.tiff, XXX2.loc
% Use center if you want to compute the centroid and distance between Nuc
% and Cell. Center has the values 'off' and 'on'. The default value is
% 'off'
% Threshold is a vector of threshold, where each enter correspond to the
% experience with the same index. By default Threshold is a N*1 zeros vector, where
% N is the number of exp.
% If length(threshold)=1, the same threshold will be used for all the data
% Ex: Threshold= [25, 30, 120, 0, 15];
% matbatch('C:/Users/XXXX/Documents/ExpList', 'on',Threshold)

if ~exist('center', 'var') || isempty(center)
    center='off';
end

files= dir(pathname);
for i=1:numel(files)
    if ~isempty(regexpi(files(i).name, '^cell(_)?[0-9]+(.tif)(f)?','match'))
        Cell{i} = files(i).name;
    elseif  ~isempty(regexpi(files(i).name, '^nuc[a-z]*(_)?[0-9]+(.tif)(f)?','match'))
        Nuc{i} = files(i).name;
    elseif ~isempty(strfind(files(i).name, 'loc'))
        loc_file{i}=files(i).name;
    end
end

Nuc = sort(Nuc(~cellfun('isempty',Nuc)));
Cell = sort(Cell(~cellfun('isempty',Cell)));
loc_file = sort(loc_file(~cellfun('isempty',loc_file)));

if (~(length(Nuc)==length(Cell) && length(Cell)==length(loc_file)))
    error('Erreur fond. avec le nom des fichiers, merci de les verifier\n');
else
    if ~exist('threshold', 'var') || isempty(threshold) || length(threshold)~=length(Nuc)
        if(length(threshold)==1)
            threshold=zeros(length(Nuc),1)+threshold;
        else
            threshold=zeros(length(Nuc),1)-1;
        end
    end
    for i=1:length(Nuc)
        ARN_quant(strcat(pathname,Cell{i}), strcat(pathname,Nuc{i}), strcat(pathname,loc_file{i}),threshold(i), center);
    end
end