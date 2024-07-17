function plotClusterOnlyTest(M,option,Goption,clusterN)

if nargin<3
    Goption=0;
end
if nargin<2
    Goption=0;
    option=2;
end
%same as plotCluster but plot out the clusters in better graphics

Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
Peak=Peak(:,:);                    %make odor/conc into a single dimension

O=sum(M.Data.Sort.aOdor);
C=sum(M.Data.Sort.aConc);
G=sum(M.Data.Sort.aGlom);
rOdorAbr=M.Experiment.Odor.Abr(M.Data.Sort.vOdor);
origlabel=cell(O*C,1);
glomlabel=cell(G,1);
for i=1:G
    glomlabel(i)=cellstr(num2str(i));
end
for i=1:O
    for j=1:C
        origlabel((i-1)*C+j)=strcat(rOdorAbr(i),num2str(j));
    end
end

switch option
    case 1
        YD=pdist(Peak,'euclidean'); %calculating using Euclidean Distance
        XD=pdist(Peak','euclidean');
        PlotTitle='Peak Euclidean Distance Plot';
    case 2
        [x y]=size(Peak);
        l=x*(x-1)/2;
        NormDPDist=zeros(1,1:l);
        k=1;
        for i=1:x-1
            if i>=x
                break
            else
                for j=i+1:x
                NormDPDist(k)=1-sum(dot(Peak(i,:),Peak(j,:)))/sqrt(sum(dot(Peak(i,:),Peak(i,:)))*sum(dot(Peak(j,:),Peak(j,:))));
                k=k+1;
                end
            end
        end
        YD=NormDPDist;
        
        l=y*(y-1)/2;
        NormDPDist=zeros(1,1:l);
        k=1;
        for i=1:y-1
            if i>=y
                break
            else
                for j=i+1:y
                NormDPDist(k)=1-sum(dot(Peak(:,i),Peak(:,j)))/sqrt(sum(dot(Peak(:,i),Peak(:,i)))*sum(dot(Peak(:,j),Peak(:,j))));
                k=k+1;
                end
            end
        end
        XD=NormDPDist;
        PlotTitle='NormDotProd Plot';
    case 3
        zPeak=zscore(Peak);
        YD=pdist(zPeak,'euclidean'); %calculating using Z Score
        XD=pdist(zPeak','euclidean');
        PlotTitle='Z Score Plot';
    case 4
        zPeak=normr(Peak);
        YD=pdist(zPeak,'euclidean'); %calculating using Normalized Peak
        XD=pdist(zPeak','euclidean');
        PlotTitle='Normalized Peak Plot';
    case 5
        zPeak=normr(Peak);
        zPeak=tiedrank(zPeak);        
        YD=pdist(zPeak,'euclidean'); %calculating using Peak Rank
        XD=pdist(zPeak','euclidean');
        PlotTitle='Rank Plot';
end

switch Goption
    case 0
        figure ('Position',[5 5 600 800]);whitebg('w')
        YZ=linkage(YD);
        H=dendrogram(YZ,0,'colorthreshold',0.1,'orientation','left','labels',glomlabel);
        set(H,'LineWidth',3,'Color','k')
        set(gca,'YDir','reverse','FontWeight','bold','FontSize',8);
        title(strcat('GlomCluster /',M.Project.Info(1,2),'/ ',PlotTitle))

        figure('Position',[30 30 600 960]);whitebg('w')
        XZ=linkage(XD); 
        HO=dendrogram(XZ,0,'orientation','right','labels',origlabel);
        %[HO,XT,xperm]=dendrogram(XZ,0,'labels',origlabel);
        set(gca,'YDir','reverse','FontWeight','bold','FontSize',8,'TickLength',[0 0]);
        %xticklabel_rotate;
        set(HO,'LineWidth',3,'Color','k')
        title(strcat('OdorCluster /',M.Project.Info(1,2),'/ ',PlotTitle))

    case 1
        figure ('Position',[5 5 600 800]);whitebg('w')
        YZ=linkage(YD);
        [H, T]=dendrogram(YZ,clusterN,'colorthreshold',0.3,'orientation','left','labels',glomlabel);
        clusterNm(1:clusterN)=0;
        for i=1:clusterN
            clusterNm(i)=length(find(T==i));
        end
        
        
        set(H,'LineWidth',3,'Color','k')
        set(gca,'YDir','reverse','FontWeight','bold','FontSize',8);
        title(strcat('GlomCluster /',M.Project.Info(1,2),'/ ',PlotTitle))

    case 2
        figure('Position',[30 30 600 960]);whitebg('w')
        XZ=linkage(XD); 
        HO=dendrogram(XZ,0,'orientation','right','labels',origlabel);
        %[HO,XT,xperm]=dendrogram(XZ,0,'labels',origlabel);
        set(gca,'YDir','reverse','FontWeight','bold','FontSize',8,'TickLength',[0 0]);
        %xticklabel_rotate;
        set(HO,'LineWidth',3,'Color','k')
        title(strcat('OdorCluster /',M.Project.Info(1,2),'/ ',PlotTitle))
end