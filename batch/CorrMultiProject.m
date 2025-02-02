function CorrMultiProject()

dataDir = 'L:\Lab Member data files\Qiang\bulb imaging\GIAProccessed\Pooled for KIR-SPH-OIVT animal\MUTANT';
pDirs = dir(dataDir);

PeakCtl = [];
label = [];
for i=1:length(pDirs)
    if strcmp(pDirs(i).name,'.')==1 || strcmp(pDirs(i).name,'..')==1
        continue;
    end
    tDir = fullfile(dataDir,pDirs(i).name);
    toLoad = fullfile(tDir,'Project.mat');
    disp(tDir);
    M = load(toLoad);
%   For single concentration, just change the N in M.Data.Sort.Peak(N,:,:)
    Peak = M.Data.Sort.Peak(:,:,:);
    Peak = permute(Peak,[2 3 1]);
    Peak = Peak(:,:);
    Peak = permute(Peak, [2 1]);
       
    PeakCtl = [PeakCtl Peak];
end
    label = M.Experiment.Odor.Abr(M.Data.Sort.vOdor);
    
O=sum(M.Data.Sort.aOdor);
C=sum(M.Data.Sort.aConc);

rOdorAbr=M.Experiment.Odor.Abr(M.Data.Sort.vOdor);
origlabel=cell(O*C,1);

for i=1:O
    for j=1:C
        origlabel((i-1)*C+j)=strcat(rOdorAbr(i),num2str(j));
    end
end

Y = pdist(PeakCtl);
Z = linkage(Y);
figure;
[H, YT,yperm]=dendrogram(Z,0,'orientation','right','labels',origlabel);
set(gca,'FontSize',8,'FontWeight','bold','LineWidth',2)
set(H,'LineWidth',2,'Color','k')

Y = pdist(PeakCtl,'cosine');
Z = linkage(Y);
figure; 
[H, YT,yperm]=dendrogram(Z,0,'orientation','right','labels',origlabel);
set(gca,'FontSize',8,'FontWeight','bold','LineWidth',2)
set(H,'LineWidth',2,'Color','k')