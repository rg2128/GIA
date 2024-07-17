%calculating similarity in receptive field among glomeruli, plot the
%similary onto physical map. 
%
%The function take the form
%PlotGlomSimMapMulti3(M,option,clusterS,GaussFrom)
%
%Input:
%M: the structure contains the dataset. Usually found as project.m in one
%of the GIA folders.
%
%options: 1, using euclidean distance; 2, Default. using NormDotProduct(correlation); 3, using
%normalized ranks followed by euclidean clustering.
%
%clusterS is vector of 3 elements. Default=[4 8 20]. The numbers, in increasing order, indicate
%the number of of clusters to calculate the similiaries.
%
%GaussForm dictate the gaussian function used to blur the image. It takes
%the form: GaussForm.A=[x y], GaussForm.Se=se. with x y being the size in x and y direction
%for the Gaussian filter and se=the standard deviation of the Gaussian
%curve. Default GaussForm.A=[20 20], GaussForm.Se=3.
% Example of usage:
%1. PlotGlomSimMapMulti2(M)
%2. PlotGlomSimMapMulti2(M,1)
%3. PlotGlomSimMapMulti2(M,2,[4 8 15])
%4. GaussForm.A=[20 20]; 
%   GaussForm.Se=3;
%   PlotGlomSimMapMulti2(M,2,[4 8 15],GaussForm)
function PlotGlomSimMapMulti4(M,option,clusterS,GaussForm)

addpath('../plotting')
if nargin<4
    GaussForm.A=[20 20];GaussForm.Se=3;
end
if nargin<3
    GaussForm.A=[20 20];GaussForm.Se=3;
    clusterS=[3 6 18];
end
if nargin<2
    option=2;
end

%get peak information   
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
clusterColor=zeros(G,3);
figure('position',[5 5 1200 400])
        Tin=cluster(ZYD,'maxclust',clusterS(1));
            color = ZYD(end-clusterS(1)+2,3)-eps;
 subplot(1,3,1)
 dendrogram(ZYD, 0, 'colorthreshold', color);
        T(:,1)=Tin;
        Tin=cluster(ZYD,'maxclust',clusterS(2));
                color = ZYD(end-clusterS(2)+2,3)-eps;
 subplot(1,3,2)
 dendrogram(ZYD, 0, 'colorthreshold', color);
        T(:,2)=Tin;
        Tin=cluster(ZYD,'maxclust',clusterS(3));
                color = ZYD(end-clusterS(3)+2,3)-eps;
 subplot(1,3,3)
 dendrogram(ZYD, 0, 'colorthreshold', color);
        T(:,3)=Tin;
    
        Tarr=T;
            Tarr1n=max(Tarr(:,1));

            clusterColor(:,1)=round(Tarr(:,1)/Tarr1n); modr=mod(Tarr(:,1),Tarr1n);
            clusterColor(:,2)=round(modr(:,1)/4); modg=mod(modr(:,1),2);
            clusterColor(:,3)=round(modg(:,1)/2);

            for i=1:clusterS(1)
                for j=2:3
                    Ind1=T(:,1)==i;
                    G1uni=unique(T(Ind1,j));
                    G1size=length(G1uni);
                        for k=1:G1size
                            Tg1=T(:,j)==G1uni(k);
                            Tarr(Tg1,j)=k-1;
                        end
                end
            end
    
    
    
    % Plot Font Size Settings
tFS=15;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
MS=300;      % Marker Size       
   %set ROI indices     
Lx=cell2mat(M.Project.ROI(3));              % X pixel #
Ly=cell2mat(M.Project.ROI(3));              % Y pixel #
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
S=zeros(sum(M.Data.Sort.aGlom),1)+MS;       % Marker Size vector                       
X=linspace(0,(Lx-1)*SF,Lx);                 % X axis length vector
Y=linspace(0,(Ly-1)*SF,Ly);                 % Y axis length vector
ROI=FlipROI(M);
ROIx=ROI(M.Data.Sort.vGlom,1);              % Sorted ROI x coordinates
ROIy=ROI(M.Data.Sort.vGlom,2);              % Sorted ROI y coordinates

%set point spread function using structure GaussForm
PSF = fspecial('gaussian',GaussForm.A,GaussForm.Se);

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

figure('position',[5 5 1500 1000])

    subplot(2,3,1)
        Z=clusterColor*0.6;
        %Z(:,[2 3])=0.4;      
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k');        set(gcf,'Color','w')
        xlim([0 max(X)]);        ylim([0 max(Y)])
            im=getframe;
            ClustImage1= frame2im(im);    %Return associated image data Truecolor system
        ClustImageBlurred1 = imfilter(ClustImage1,PSF,'circular','conv');
        title({PlotTitle;M.Project.Folder},'FontSize',tFS)
    
    subplot(2,3,4)
        imagesc(ClustImageBlurred1);

    subplot(2,3,2)
        Z=clusterColor;
        Z(:,1)=abs(clusterColor(:,1)-(Tarr(:,1)-1)/clusterS(1));
        Z(:,2)=abs(clusterColor(:,2)-Tarr(:,2)/max(Tarr(:,2)));
        Z=Z*0.8;      
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k'); 
        xlim([0 max(X)]);        ylim([0 max(Y)])
            im=getframe;
            ClustImage2= frame2im(im);    %Return associated image data 
        ClustImageBlurred2 = imfilter(ClustImage2,PSF,'circular','conv');
    subplot(2,3,5)
        imagesc(ClustImageBlurred2);

    subplot(2,3,3)
        %Z=abs(clusterColor(:,:)-Tarr(:,:)/clusterS(3));
        Z=clusterColor;
        Z(:,1)=abs(clusterColor(:,1)-(Tarr(:,1)-1)/clusterS(1));
        Z(:,2)=abs(clusterColor(:,2)-Tarr(:,2)/max(Tarr(:,2)));
        Z(:,3)=abs(clusterColor(:,3)-Tarr(:,3)/max(Tarr(:,3)));
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k'); 
        xlim([0 max(X)]);        ylim([0 max(Y)])
            im=getframe(gca);
            ClustImage3= frame2im(im);    %Return associated image data 
        ClustImageBlurred3 = imfilter(ClustImage3,PSF,'circular','conv');
    subplot(2,3,6)
        imagesc(ClustImageBlurred3);
