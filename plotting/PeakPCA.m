%calculate PCA scores 
%This function perform PCA analyses on the dataset and save the relevant
% data in file PeakPCA.m, which is in the same directory as the main dataset project.m.
%
%Four types of PCA values are calculated, as followed.
%1: use peak intensity data
%2: use peak Z scores
%3: use normalized peak intensity. The normalization generate values
%according to: xi=Xi/sqrt(sum(Xi^2).
%4: use normalized peak ranks. In this case, the normalized peak values are
%ranked for each odor application, using tiedrank function

function PeakPCA

[FileName,PathName] = uigetfile('C:/GIA/*.mat');
M= load(strcat(PathName,FileName));
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
[coefs,scores latent]=princomp(zPeak');
PCAdata.Peakdata.coefs=coefs;
PCAdata.Peakdata.scores=scores;
PCAdata.Peakdata.latent=latent;

zPeak=zscore(Peak');
[coefs,scores latent]=princomp(zPeak);
PCAdata.PeakZScore.coefs=coefs;
PCAdata.PeakZScore.scores=scores;
PCAdata.PeakZScore.latent=latent;

zPeak=normr(Peak);
[coefs,scores latent]=princomp(zPeak');
PCAdata.PeakNorm.coefs=coefs;
PCAdata.PeakNorm.scores=scores;
PCAdata.PeakNorm.latent=latent;

zPeak=normr(Peak);
zPeak=tiedrank(zPeak);
[coefs,scores latent]=princomp(zPeak');
PCAdata.PeakRank.coefs=coefs;
PCAdata.PeakRank.scores=scores;
PCAdata.PeakRank.latent=latent;

save(strcat(PathName,'PCAdata.mat'),'Odors','PCAdata');