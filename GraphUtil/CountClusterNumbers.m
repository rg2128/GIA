function SimMatrix=CountClusterNumbers()
%%
load('Project.mat','Data')
thresholds = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8];
option = 2;

%% get peak information   
Peak=permute(Data.Sort.Peak,[2 1 3]); %obtain data
%make odor/conc into a single dimension, so rows are glomeruli
Peak=Peak(:,:);                         

%% compute pairwise distance
switch option
    case 1
        YD=pdist(Peak,'euclidean'); %calculating using Euclidean Distance
        PlotTitle='Euclidean Distance Similarity Plot';
    case 2
        %Calculating with NormDotProduct
        % simplified by elden here
        YD=pdist(Peak,'cosine');
        PlotTitle='Cosine Similarity Plot';
    case 3
        %calculating using ranked response
        zPeak=normr(Peak);
        zRank=tiedrank(zPeak);
        YD=pdist(zRank,'euclidean');
        PlotTitle='Ranked Response Similarity Plot';
end

%% linkage
ZYD=linkage(YD,'complete');


for i=1:length(thresholds)
    T = cluster(ZYD,'Cutoff',thresholds(i),'criterion','distance'); 
    nc = length(unique(T));
    tClusterNumber = [];
    for j=1:nc
        tClusterNumber = [tClusterNumber sum(T==j)];
    end
    ClusterNumbers{i} = tClusterNumber    
end

save('clustercount.mat', 'ClusterNumbers');
