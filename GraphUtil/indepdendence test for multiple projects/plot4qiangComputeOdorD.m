function compare = plot4qiangComputeOdorD(M)
%% 4 PCA and 5 pdist for each odor representation
%  Elden Yu @ Jun 30 2010

%% rearranged (selected and sorted) odor CAS in our project
if ~isfield(M.Experiment.Odor,'CasNumber')
    GIAmessage('title','Warning','message','Odors have no CAS numbers attached')
end
if ~isfield(M.Data,'Sort')
    GIAmessage('title','Warning','message','Rearrange not done yet')
end
OurCAS = M.Experiment.Odor.CasNumber(M.Data.Sort.vOdor);

%% load all saved odor descriptors
load NewOdorDB; % qiang has some supplementary CAS here
load optimizedDescriptors;

%% find the index of our CAS in 2718 CAS (2 repeats in 2718)
[indHasDesc, OurCasLoc] = ismember(OurCAS,CAS);

% %% find index for our odors in saved 2718 CAS
% indOurCAS = zeros(1,length(OurCAS));
% for i = 1:length(OurCAS)
%     foundYet = 0;
%     for j = 1:length(CAS)
%         if strcmp(OurCAS{i},CAS{j})
%             foundYet = 1;
%             break;
%         end
%     end
%     if foundYet
%         indOurCAS(i) = j;
%     end
% end

%% some odors not there
OurOdorNoDesc = OurCAS(indHasDesc==0);
disp(sprintf('total %d odors have no CAS',length(OurOdorNoDesc)));
for i=1:length(OurOdorNoDesc)
    disp(OurOdorNoDesc{i});
end


%% on our odor data: #conc. * #glom. responses in a descriptor
%  need to take aOdor,vOdor into account
tmp = permute(M.Data.Sort.Peak,[3 2 1]);
allOdor = odorDB(:,:);
if size(M.Data.Sort.Peak,1)==1
    indResponse = sum(tmp,2)>eps;
    OurRep{1} = tmp(indHasDesc & indResponse,:);
    % 
    TheirRep{1,1} = allOdor(OurCasLoc(indHasDesc & indResponse),:);
    TheirRep{1,2} = allOdor(OurCasLoc(indHasDesc & indResponse),optimizedDescriptors);    
else
    tmp1 = tmp(:,:);
    indResponse = sum(tmp1,2) > eps;
    OurRep{1} = tmp1(indHasDesc & indResponse,:);
    TheirRep{1,1} = allOdor(OurCasLoc(indHasDesc & indResponse),:);
    TheirRep{1,2} = allOdor(OurCasLoc(indHasDesc & indResponse),optimizedDescriptors);    
    for i=1:size(M.Data.Sort.Peak,1)
        tmp2 = tmp(:,:,i);
        indResponse = sum(tmp2,2) > eps;
        OurRep{1+i} = tmp2(indHasDesc & indResponse,:);
        TheirRep{1+i,1} = allOdor(OurCasLoc(indHasDesc & indResponse),:);
        TheirRep{1+i,2} = allOdor(OurCasLoc(indHasDesc & indResponse),optimizedDescriptors);            
    end
end

%% process all types of data representation
nOption = 5;
OurPDist = cell(length(OurRep),nOption);
TheirPDist = cell(length(OurRep),2,nOption);
for i=1:length(OurRep)
    tRep1 = OurRep{i};
    tRep2 = TheirRep{i,1};
    tRep3 = TheirRep{i,2};
    for j=1:5
        if j==5
            tPDist1 = pdist(tRep1,'cosine');
            tPDist2 = pdist(tRep2,'cosine');
            tPDist3 = pdist(tRep3,'cosine');
        else
            tPDist1 = pdist(processRaw(tRep1,j),'euclidean');
            tPDist2 = pdist(processRaw(tRep2,j),'euclidean');
            tPDist3 = pdist(processRaw(tRep3,j),'euclidean');
        end
        OurPDist{i,j} = tPDist1;
        TheirPDist{i,1,j} = tPDist2;
        TheirPDist{i,2,j} = tPDist3;
    end    
end


%% 
save(fullfile(M.Project.Folder,'compare2.mat'),...
     'OurRep','TheirRep','OurPDist','TheirPDist');
%% plots


% function [pca0, pdist0] = compute4pca5pdist(NbyP)
% %% compute 4 PCA and 5-1 pdist
% N = size(NbyP,1);
% P = size(NbyP,2);
% 
% % original version
% ZZ = NbyP;
% [coefs,scores] = princomp(ZZ);
% pca0.original.coefs = coefs;
% pca0.original.scores = scores;    
% pdist0.original = pdist(ZZ,'euclidean');
% %pdist0.cosine = pdist(ZZ,'cosine');
% 
% % zscore version
% ZZ = zscore(NbyP);
% [coefs,scores]=princomp(ZZ);
% pca0.zscore.coefs = coefs;
% pca0.zscore.scores = scores;  
% pdist0.zscore = pdist(ZZ,'euclidean');
% 
% % normr version
% ZZ=normr(NbyP);
% ZZ(isnan(ZZ))=0;
% [coefs,scores]=princomp(ZZ);
% pca0.normr.coefs = coefs;
% pca0.normr.scores = scores;  
% pdist0.normr = pdist(ZZ,'euclidean');
% 
% % tiedrank version
% ZZ=normr(NbyP);
% ZZ(isnan(ZZ))=0;
% ZZ=tiedrank(ZZ);
% [coefs,scores]=princomp(ZZ);
% pca0.tiedrank.coefs = coefs;
% pca0.tiedrank.scores = scores;
% pdist0.tiedrank = pdist(ZZ,'euclidean');

function ZZ = processRaw(NbyP,option)
switch option
    case 1
        ZZ = NbyP;
    case 2
        ZZ = zscore(NbyP);
    case 3
        ZZ=normr(NbyP);
        ZZ(isnan(ZZ))=0;
    case 4
        ZZ=normr(NbyP);
        ZZ(isnan(ZZ))=0;
        ZZ=tiedrank(ZZ);
    otherwise
        error('unknown option for data processing in pdist')
end