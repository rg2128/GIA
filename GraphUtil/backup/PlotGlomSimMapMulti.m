%calculating similarity in receptive field among glomeruli, plot the
%similary onto physical map. 
%
%The function take the form
%T=PlotGlomSimMapGF(M,option,cutoff,depth,sizelimit)
%sizelimit eliminate from the plot the clusters with members less the
%cutoff and depth are the same as in cluser().
%sizelimit
%
%Returns the vectors T: the number corresponds to the cluster each
%glomerulus belong
%R: pairwise distance vector
%
%Input:
%M: the structure contains the dataset. Usually found as project.m in one
%of the GIA folders.
%
%options: 1, using euclidean distance; 2, using NormDotProduct; 3, using
%normalized ranks followed by euclidean clustering.
%
%clusterN is the number of clusters to calculate the similiaries.
%cutoff value provides an option to display the values with a flat top
%instead of pure Gaussian. Default is set at 0, no cutoff. cutoff=1 means
%all values within 1/e are set at the same.

function PlotGlomSimMapMulti(M,option,clusterS)

if nargin<3
    clusterS=[4 8 20];
    option=2;
end
if nargin<2
    option=2;
end

addpath('../plotting')
    
Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
Peak=Peak(:,:);                         %make odor/conc into a single dimension

switch option
    case 1
        YD=pdist(Peak,'euclidean'); %calculating using Euclidean Distance
        PlotTitle='Euclidean Distance Similarity Plot';
    case 2
        %Calculating with NormDotProduct
        x=length(Peak(:,1));
        l=x*(x-1)/2;
        NormDPDist(1:l)=0;
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
        PlotTitle='NormDotProduct Similarity Plot';
    case 3
        %calculating using ranked response
        zPeak=normr(Peak);
        zRank=tiedrank(zPeak);
        YD=pdist(zRank,'euclidean');
        PlotTitle='Ranked Response Similarity Plot';
end
    
ZYD=linkage(YD,'complete');
G=sum(M.Data.Sort.aGlom);
T=zeros(G,3);
T(:,1)=cluster(ZYD,'maxclust',clusterS(1));
T(:,2)=cluster(ZYD,'maxclust',clusterS(2));
T(:,3)=cluster(ZYD,'maxclust',clusterS(3));

% assign colors according to clustering
clusterColor=zeros(G,3);
for i=1:4
cluster1= T(:,1)==i;
clusterColor(cluster1,1)=(i+1)/5;   %assign the blue channel
cluster1ID=find (T(:,1)==i);

CM=T(cluster1,:);%[CMn y]=size(CM); %get members belonging to cluster1
CU1=unique(CM(:,2));                %get unique numbers of cluster1
CU1num=length(CU1);

    for j=1:CU1num
        cluster2= find(T(cluster1ID,2)==CU1(j));
        clusterColor(cluster1ID(cluster2),2)=(j+1)/(CU1num+1); %assign the green channel
        
            cluster2ID=find (T(cluster1,2)==CU1(j));

            CM2=T(cluster2,:);%[CMn2 y]=size(CM2); %get members belonging to cluster1
            CU2=unique(CM2(:,3));                %get unique numbers of cluster1
            CU2num=length(CU2);

                for k=1:CU2num
                    cluster3= T(cluster2ID,3)==CU2(k);
                    clusterColor(cluster1ID(cluster2ID(cluster3)),3)=(k+1)/(CU2num+1);% assigning red channel

                    clear cluster3
                end
        clear cluster2
    end
end
% GlomColor=zeros(G,3);
% for i=1:3
%         for j=1:clusterS(i)
%             clusterMid= T(:,i)==j;
%             GlomColor(clusterMid,(4-i))=j/clusterS(i);
%         end
% end

        
 % Plot Font Size Settings
tFS=15;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
MS=100;      % Marker Size       
        
Lx=cell2mat(M.Project.ROI(3));              % X pixel #
Ly=cell2mat(M.Project.ROI(3));              % Y pixel #
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
S=zeros(sum(M.Data.Sort.aGlom),1)+MS;       % Marker Size vector                       
X=linspace(0,(Lx-1)*SF,Lx);                 % X axis length vector
Y=linspace(0,(Ly-1)*SF,Ly);                 % Y axis length vector
ROI=FlipROI(M);
ROIx=ROI(M.Data.Sort.vGlom,1);              % Sorted ROI x coordinates
ROIy=ROI(M.Data.Sort.vGlom,2);              % Sorted ROI y coordinates

PSF1 = fspecial('gaussian',[40 40],15);
PSF2 = fspecial('gaussian',[30 30],10);
PSF3 = fspecial('gaussian',[20 20],5);

% figure('position',[5 5 320 320])
% 
%         Z=clusterColor;
%         scatter(ROIx*SF,ROIy*SF,S,Z,'filled')
%         set(gca,'Color',[0.2 0.2 0.2])
%         set(gcf,'Color','w')
%         set(gcf, 'InvertHardCopy', 'off');
%         xlim([0 max(X)])
%         ylim([0 max(Y)])
%         axis ij

figure('position',[5 5 960 960])

    subplot(3,3,1)
        Z=clusterColor;
        Z(:,[2 3])=0;      
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k');        set(gcf,'Color','w')
        set(gcf, 'InvertHardCopy', 'off');
        xlim([0 max(X)]);        ylim([0 max(Y)])
        title({PlotTitle;M.Project.Folder},'FontSize',tFS)
        
        subplot(3,3,2)
        scatter(ROIx*SF,ROIy*SF,S*3,Z,'filled'), axis ij
        set(gca,'Color','k');        set(gcf,'Color','w')
        set(gcf, 'InvertHardCopy', 'off');
        xlim([0 max(X)]);        ylim([0 max(Y)])
            im=getframe;
            ClustImage1= frame2im(im);    %Return associated image data 
                        %Truecolor system
        ClustImageBlurred1 = imfilter(ClustImage1,PSF1,'circular','conv');
    subplot(3,3,3)
        imagesc(ClustImageBlurred1);

        
    subplot(3,3,4)
        Z=clusterColor;
        Z(:,3)=0;      
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k');        set(gcf,'Color','w')
        set(gcf, 'InvertHardCopy', 'off');
        xlim([0 max(X)]);        ylim([0 max(Y)])
        title({PlotTitle;M.Project.Folder},'FontSize',tFS)
        
        subplot(3,3,5)
        Z(:,[1 3])=0;
        scatter(ROIx*SF,ROIy*SF,S*2,Z,'filled'), axis ij
        set(gca,'Color','k');        set(gcf,'Color','w')
        set(gcf, 'InvertHardCopy', 'off');
        xlim([0 max(X)]);        ylim([0 max(Y)])
            im=getframe;
            ClustImage2= frame2im(im);    %Return associated image data 
                        %Truecolor system
        ClustImageBlurred2 = imfilter(ClustImage2,PSF2,'circular','conv');
    subplot(3,3,6)
        imagesc(ClustImageBlurred2);

    subplot(3,3,7)
        Z=clusterColor;
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k');        set(gcf,'Color','w')
        set(gcf, 'InvertHardCopy', 'off');
        xlim([0 max(X)]);        ylim([0 max(Y)])
        title({PlotTitle;M.Project.Folder},'FontSize',tFS)
        
    subplot(3,3,8)
        Z=clusterColor;
        Z(:,[1 2])=0;
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k');        set(gcf,'Color','w')
        set(gcf, 'InvertHardCopy', 'off');
        xlim([0 max(X)]);        ylim([0 max(Y)])
        title({PlotTitle;M.Project.Folder},'FontSize',tFS)
            im=getframe;
            ClustImage2= frame2im(im);    %Return associated image data 
                        %Truecolor system
        ClustImageBlurred3 = imfilter(ClustImage2,PSF3,'circular','conv');
    subplot(3,3,9)
        imagesc(ClustImageBlurred3);
%         colormap jet
%         colorbar
%   plot individual clusters

% figure
%     for i=1:clusterN
%         Z=zeros(length(T),1);
%         list= T==i;
%         Z(list)=1;
%         [X Y I]=ROIfield(M,Z,1,cutoff);%colormap gray
%         subplot(rown,coln,i)
%         imagesc(X,Y,I)
%     end
%         figure
%         imagesc(X,Y,I);
%         
%         title(PlotTitle)