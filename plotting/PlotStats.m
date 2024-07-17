function PlotStats(M)

if isequal(exist(fullfile(M.Project.Folder,'Analysis'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder),'Analysis')
end
% Check for Stats Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis/Stats'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'Analysis'),'Stats')
end

%set file path
PathName=fullfile(M.Project.Folder,'Analysis/Stats');
ProjectName = M.Project.Info{1,2};  



C=sum(M.Data.Sort.aConc);
I=PeakPCAM(M);

for option=1:4
    PlotPeakPCA(I,option,0,1:C)
    filename=strcat(ProjectName,'-',num2str(option),'-PCA.fig');
    saveas(gcf,strcat(PathName,'/',filename))
    filenamej=strcat(ProjectName,'-',num2str(option),'-PCA.jpg');
    print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filenamej));
    close
end
for option=1:5
    plotCluster(M,option)
    filename=strcat(ProjectName,'-',num2str(option),'-cluster.fig');
    saveas(gcf,strcat(PathName,'/',filename))
    filenamej=strcat(ProjectName,'-',num2str(option),'-cluster.jpg');
    print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filenamej))
    close
end
for option=1:5
    plotClusterOnly(M,option,2)
    filename=strcat(ProjectName,'-',num2str(option),'-OdorDendrogram');
    print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filename,'.jpg'));
    saveas(gcf,strcat(PathName,'/',filename,'.fig'))
    close
end
for option=1:5
    plotClusterOnly(M,option,1)
    filename=strcat(ProjectName,'-',num2str(option),'-GlomDendrogram');
    print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filename,'.jpg'));
    saveas(gcf,strcat(PathName,'/',filename,'.fig'))
    close
end
    

function I=PeakPCAM(M)
Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
Peak=Peak(:,:);                    %make odor/conc into a single dimension
O=sum(M.Data.Sort.aOdor);
C=sum(M.Data.Sort.aConc);
rOdorAbr=M.Experiment.Odor.Abr(M.Data.Sort.vOdor);
origlabel=cell(O*C,1);
for i=1:O
    for j=1:C
        origlabel((i-1)*C+j)=strcat(rOdorAbr(i),num2str(j));
    end
end

Odors.O=O;
Odors.C=C;
Odors.Abr=rOdorAbr;
Odors.label=origlabel;

zPeak=Peak;
[coefs,scores]=princomp(zPeak');
PCAdata.Peakdata.coefs=coefs;
PCAdata.Peakdata.scores=scores;

zPeak=zscore(Peak);
[coefs,scores]=princomp(zPeak');
PCAdata.PeakZScore.coefs=coefs;
PCAdata.PeakZScore.scores=scores;

zPeak=normr(Peak);
[coefs,scores]=princomp(zPeak');
PCAdata.PeakNorm.coefs=coefs;
PCAdata.PeakNorm.scores=scores;

zPeak=normr(Peak);
zPeak=tiedrank(zPeak);
[coefs,scores]=princomp(zPeak');
PCAdata.PeakRank.coefs=coefs;
PCAdata.PeakRank.scores=scores;

I.Odors=Odors;
I.PCAdata=PCAdata;

save(fullfile(M.Project.Folder,'PCAdata.mat'));