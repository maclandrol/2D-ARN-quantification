function mergebatch(path, center,threshold)
%% Mergebatch(path, threshold, center)
% batchmode of Mergeandquant.
% path is the directory name which contains the file to merge and to
% quantify. Theses files must use this format:
% Exp1 ----> Cell1.tiff, Nuc1.tiff, merge1.fus, ARN1.loc ....
% Center is a on/off argument and decide whether or not you want centroid
% and distance computation.

%Thresold est un vecteur des threshold dans l'ordre pour chaque exp.
%pour limiter le nombre de fichier créé, j'ai préféré ne pas faire un
%fichier contenant la liste des threshold. --Un programme perd de sa
%maniabilité si trop complexe--. Center est par defaut off et est
%facultatif

if ~exist('center', 'var') || isempty(center)
    center='off';
end

files= dir(path);
for i=1:numel(files)
    if ~isempty(regexpi(files(i).name, '^cell(_)?[0-9]+(.tif)(f)?','match'))
        Cell{i} = files(i).name;
    elseif  ~isempty(regexpi(files(i).name, '^nuc[a-z]*(_)?[0-9]+(.tif)(f)?','match'))
        Nuc{i} = files(i).name;
    elseif ~isempty(strfind(files(i).name, '.loc'))
        arn_file{i}=files(i).name;
        
    elseif ~isempty(strfind(files(i).name, '.fus'))
        fuse_file{i}=files(i).name;
        
    elseif ~isempty(regexpi(files(i).name, '^cell(_)?[0-9]+(_)?(out1.txt)','match'))
        out1_file{i}=files(i).name;
    end
end
Nuc = sort(Nuc(~cellfun('isempty',Nuc)));
Cell = sort(Cell(~cellfun('isempty',Cell)));
arn_file = sort(arn_file(~cellfun('isempty',arn_file)));
fuse_file = sort(fuse_file(~cellfun('isempty',fuse_file)));
out1_file = sort(out1_file(~cellfun('isempty',out1_file)));
correct=[length(Nuc); length(Cell);length(arn_file);length(fuse_file);length(out1_file)];

if ~(length(correct)==sum(correct==length(Cell)))
    error('Erreur fond. avec le nom des fichiers, merci de les verifier\n');
else
    if ~exist('threshold', 'var') || isempty(threshold) || length(threshold)~=length(Nuc)
        threshold=zeros(length(Nuc),1)-1;
    end
    parfor i=1:length(Nuc)
        mergeandquant(strcat(path,fuse_file{i}), strcat(path,Cell{i}),strcat(path, Nuc{i}), strcat(path, out1_file{i}), strcat(path,arn_file{i}), threshold(i), center)
    end
end


