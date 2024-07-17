load('myrecord.mat');

nIter = length(allHistoryCor);
allBestCor = zeros(1,nIter);
for i=1:nIter
    tBest = allHistoryCor{i};
    tBest = tBest(end);
    allBestCor(i) = tBest;
end
[allBestCorSorted allBestCorInd] = sort(allBestCor,'descend');
figure;plot(allBestCorSorted);
allBestCorSorted(1)  % 0.8483
% allHistoryCor{allBestCorInd(1)}
allBestSet{allBestCorInd(1)}
% allOption{allBestCorInd(1)}.Res
% allOption{allBestCorInd(1)}.Des


%% analyze if removing tiedrank
allBestCorWithoutTiedrank = [];
Ind2 = [];
for i=1:nIter
    if strcmp(allOption{i}.Res.Pre,'Tiedrank') ||  strcmp(allOption{i}.Des.Pre,'Tiedrank') ...
    ||   strcmp(allOption{i}.Res.Pre,'ZN') ||  strcmp(allOption{i}.Des.Pre,'ZN')            
        continue;
    end
    tBest = allHistoryCor{i};
    tBest = tBest(end);
    allBestCorWithoutTiedrank = [allBestCorWithoutTiedrank tBest];
    Ind2 = [Ind2 i];
end
[allBestCorSorted2 tmp2] = sort(allBestCorWithoutTiedrank,'descend');
figure;plot(allBestCorSorted2)
Ind2 = Ind2(tmp2);
allBestCorSorted2(1)   % 0.6871
allBestSet{Ind2(1)}
allOption{Ind2(1)}.Res
allOption{Ind2(1)}.Des
% best = -inf;
% bestI = [];
% for i=1:576
%     tCor = allHistoryCor{i};
%     tBest = tCor(end);
%     if tBest>best
%         best = tBest;
%         bestI = i;
%     end
% end
% best
% bestI