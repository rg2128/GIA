%plot clustered graphs showing 

function plotClusterProject(Data,option)
Peak=permute(Data.Sort.Peak,[2 1 3]); %obtain data
Peak=Peak(:,:);                    %make odor/conc into a single dimension

O=sum(Data.Sort.aOdor);
C=sum(Data.Sort.aConc);
G=sum(Data.Sort.aGlom);
rOdorAbr=Experiment.Odor.Abr(Data.Sort.vOdor);
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

figure ('Position',[30 30 960 800]);whitebg('w')
subplot ('Position',[0.78 0.1 0.19 0.6])
YZ=linkage(YD);
[H, YT,yperm]=dendrogram(YZ,0,'orientation','right','labels',glomlabel);
set(gca,'FontSize',8,'FontWeight','bold','LineWidth',2)
set(H,'LineWidth',2,'Color','k')
subplot ('Position',[0.1 0.76 0.65 0.2])
XZ=linkage(XD); 
[H,XT,xperm]=dendrogram(XZ,0,'labels',origlabel);
subplot ('Position',[0.1 0.1 0.65 0.6])
set(gca,'FontSize',8,'FontWeight','bold','LineWidth',2)
set(H,'LineWidth',2,'Color','k')
imagesc(Peak(yperm,xperm));
title(PlotTitle,'FontSize',16)

