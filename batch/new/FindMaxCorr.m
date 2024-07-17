function [historyCor,bestSet] = FindMaxCorr(data,option)
%% To find the maximum correlation coefficient 
%  between I.  pdist of a subset of odor descriptors
%  and     II. pdist of odor responses
%  note that:
%  1. there are 2^P*6*2*2 ways of computing I.
%  2. there are 4*6*2*2 ways of computing II.
%  How to find the best combination to yield the maximum corr(I,II)?
%  The greedy algorithm is used for finding the subset of descriptors
%  data: 
%  Elden Yu @ 7/19/2010
tic;
%% compute ourpd and TheirReps
%  we cannot compute theirpd coz descriptors not chosen yet
ourpd = [];
TheirReps = {};
for z=1:data.cproj
    tOurCAS = data.OurCAS{z};
    [indHasDesc, OurCasLoc] = ismember(tOurCAS,data.CAS);
    tOurPeak = data.OurPeak{z};
    if size(tOurPeak,3)~=3 % skip this project if it has only 1 conc.
        continue;
    end
    switch option.Res.Rep
        case 'AllC'
            tmp = tOurPeak(:,:);
        case 'Con1'
            tmp = tOurPeak(:,:,1);
        case 'Con2'
            tmp = tOurPeak(:,:,2);
        case 'Con3'
            tmp = tOurPeak(:,:,3);
    end
    indResponse = sum(tmp,2) > eps;
    OurRep = tmp(indHasDesc & indResponse,:); 
    OurPd = ComputePd(OurRep,option.Res);
    ourpd = [ourpd OurPd];

    tmp = data.odorDB;
    TheirRep = tmp(OurCasLoc(indHasDesc & indResponse),:);
    TheirReps{end+1} = TheirRep;
end

%%
historyCor = [];
N = size(data.odorDB,2);
bestSet = [];
fullSet = 1:N;
LoopOrNot = 1;
while (LoopOrNot)
%    candidSet = setdiff(fullSet,bestSet);
    candidSet = fullSet;
    bestCor = -inf;       
    for k = 1:length(candidSet)
        %% now to decide which candidate feature works best
        workSet = [bestSet candidSet(k)];
        if k==length(candidSet) || mod(k,100)==0
            if ~isempty(historyCor)
                fprintf('bestCor=%3.2f,fixed %d features, and testing %d now\n',...
                         historyCor(end),length(bestSet),k);
            else
                fprintf('testing %d now\n',k);
            end
        end
        theirpd = [];
        for z=1:length(TheirReps)       
            tmp = TheirReps{z};
            TheirRep = tmp(:,workSet);
            TheirPd = ComputePd(TheirRep,option.Des);
            theirpd = [theirpd TheirPd];
        end
        tCor = abs(corr(ourpd',theirpd'));
        if tCor>bestCor
            bestCor = tCor;
            bestCorInd = k;
        end
    end
    bestSet = [bestSet candidSet(bestCorInd)];
    historyCor = [historyCor bestCor];    
    
    if length(historyCor)>4
        if historyCor(end-0)-historyCor(end-1)<0.004 ...
        && historyCor(end-1)-historyCor(end-2)<0.004 ...
        && historyCor(end-2)-historyCor(end-3)<0.004
            LoopOrNot=0;
        end
    end
end
bestSet
historyCor
toc;
