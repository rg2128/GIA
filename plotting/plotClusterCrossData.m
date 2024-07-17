function plotClusterCrossData()

dataDir = 'C:\GIA\all 6 conentration'; % image response folder
pDirs = dir(dataDir);

fullDesc = load('C:\Glomerulus Imaging Analysis\elden0723\lib\OdorD\NewodorDB.mat');

CommonOdor = fullDesc.CAS;

%% To caculate which odors are common among these data sets
for i=1:length(pDirs)      % for folder '10 data'
    if strcmp(pDirs(i).name,'.')==1 || strcmp(pDirs(i).name,'..')==1
        continue;
    end
    tDir = fullfile(dataDir,pDirs(i).name);
    toLoad = fullfile(tDir,'Project.mat');
    disp(tDir);
    M = load(toLoad);
    ListCAS = M.Experiment.Odor.CasNumber(M.Data.Sort.vOdor);
    [TF LOC] = ismember(ListCAS,CommonOdor);
    CommonOdor = ListCAS(TF)
end


PeakResp = [];

%% adjoint the peaks matrix together by same odor sets
for m=1:length(pDirs)
    if strcmp(pDirs(m).name,'.')==1 || strcmp(pDirs(m).name,'..')==1
        continue;
    end

    tDir = fullfile(dataDir,pDirs(m).name);
    toLoad = fullfile(tDir,'Project.mat');
    disp(tDir);
    M = load(toLoad);
    ListCAS = M.Experiment.Odor.CasNumber(M.Data.Sort.vOdor);
    [TF LOC] = ismember(CommonOdor,ListCAS);
    Peak = M.Data.Sort.Peak(:,:,LOC);
    Peak = permute(Peak,[2 3 1]);
    Peak = Peak(:,:);
    Peak = permute(Peak, [2 1]);
    PeakResp = [PeakResp Peak];
    
    if m==3;
    O=sum(M.Data.Sort.aOdor(LOC));
    C=sum(M.Data.Sort.aConc);
    rOdorAbr=M.Experiment.Odor.Abr(M.Data.Sort.vOdor(LOC));
    origlabel=cell(O*C,1);
    end
  
end


for i=1:O
    for j=1:C
        origlabel((i-1)*C+j)=strcat(rOdorAbr(i),num2str(j));
    end
end


PeakResp = PeakResp';
for i = 1:5
    option = i;
    switch option
        case 1
            YD=pdist(PeakResp,'euclidean'); %calculating using Euclidean Distance
            XD=pdist(PeakResp','euclidean');
            PlotTitle='Peak Euclidean Distance Plot';
        case 2

             [x y]=size(PeakResp);
    %         l=x*(x-1)/2;
    %         NormDPDist=zeros(1,1:l);
    %         k=1;
    %         for i=1:x-1
    %             if i>=x
    %                 break
    %             else
    %                 for j=i+1:x
    %                 NormDPDist(k)=1-sum(dot(Peak(i,:),Peak(j,:)))/sqrt(sum(dot(Peak(i,:),Peak(i,:)))*sum(dot(Peak(j,:),Peak(j,:))));
    %                 k=k+1;
    %                 end
    %             end
    %         end
    %         YD=NormDPDist;
    %         
            l=y*(y-1)/2;
            NormDPDist=zeros(1,1:l);
            k=1;
            for i=1:y-1
                if i>=y
                    break
                else
                    for j=i+1:y
                    NormDPDist(k)=1-sum(dot(PeakResp(:,i),PeakResp(:,j)))/sqrt(sum(dot(PeakResp(:,i),PeakResp(:,i)))*sum(dot(PeakResp(:,j),PeakResp(:,j))));
                    k=k+1;
                    end
                end
            end
            XD=NormDPDist;
            PlotTitle='NormDotProd Plot';
        case 3
            zPeak=(zscore(PeakResp'))';
            YD=pdist(zPeak,'euclidean'); %calculating using Z Score
            XD=pdist(zPeak','euclidean');
            PlotTitle='Z Score Plot';
        case 4
            zPeak=normr(PeakResp);
            YD=pdist(zPeak,'euclidean'); %calculating using Normalized Peak
            XD=pdist(zPeak','euclidean');
            PlotTitle='Normalized Peak Plot';
        case 5
            zPeak=normr(PeakResp);
            zPeak=tiedrank(zPeak);        
            YD=pdist(zPeak,'euclidean'); %calculating using Peak Rank
            XD=pdist(zPeak','euclidean');
            PlotTitle='Rank Plot';
    end

        
        XZ=linkage(XD); 
        figure;HO=dendrogram(XZ,0,'orientation','right','labels',origlabel);
        %[HO,XT,xperm]=dendrogram(XZ,0,'labels',origlabel);
        set(gca,'YDir','reverse','FontWeight','bold','FontSize',8,'TickLength',[0 0]);
        %xticklabel_rotate;
        set(HO,'LineWidth',3,'Color','k')
        title(PlotTitle)

end

