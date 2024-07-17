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
%clusterS is vector of 3 elements. Default=[3 6 18]. The numbers, in increasing order, indicate
%the number of of clusters to calculate the similiaries.
%
%GaussForm dictate the gaussian function used to blur the image. It takes
%the form: GaussForm.A=[x y], GaussForm.Se=se. with x y being the size in x and y direction
%for the Gaussian filter and se=the standard deviation of the Gaussian
%curve. Default GaussForm.A=[20 20], GaussForm.Se=3.
% Example of usage:
%1. PlotGlomSimMapMulti5(M)
%2. PlotGlomSimMapMulti5(M,1)
%3. PlotGlomSimMapMulti5(M,2,[4 8 15])
%4. GaussForm.A=[20 20]; 
%   GaussForm.Se=3;
%   PlotGlomSimMapMulti5(M,2,[4 8 15],GaussForm)
function SimMatrix=PlotGlomSimMapMulti6(M,option,clusterS,GaussForm)

addpath('../plotting')
if nargin<4
    GaussForm.A=[20 20];GaussForm.Se=3;
    cc=max(clusterS);
    if cc<=2
        cutoff=clusterS; clusterOp=2;
    else
        clusterOp=1;
    end
    
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
cn(1:3)=0;

SimMatrix=1-squareform(YD);
figure
imagesc(SimMatrix);
close;


figure('position',[5 5 1200 400])

        switch clusterOp
            case 1
                Tin=cluster(ZYD,'maxclust',clusterS(1));
                color = ZYD(end-clusterS(1)+2,3)-eps;
                cn(1)=clusterS(1);
           case 2
                Tin=cluster(ZYD,'cutoff',cutoff(1));
                cn(1)=length(unique(Tin));
                color = ZYD(end-cn(1)+2,3)-eps;
        end
 subplot(1,3,1)
 hden1=dendrogram(ZYD, 0, 'colorthreshold', color,'labels',num2str(sort(M.Data.Sort.vGlom)));
        T(:,1)=rearrangeT(Tin,'descend');
        switch clusterOp
            case 1
                Tin=cluster(ZYD,'maxclust',clusterS(2));
                color = ZYD(end-clusterS(2)+2,3)-eps;
                cn(2)=clusterS(2);
            case 2
                Tin=cluster(ZYD,'cutoff',cutoff(2));
                cn(2)=length(unique(Tin));
                color = ZYD(end-cn(2)+2,3)-eps;
        end
 subplot(1,3,2)
 hden2=dendrogram(ZYD, 0, 'colorthreshold', color,'labels',num2str(sort(M.Data.Sort.vGlom)));
        T(:,2)=rearrangeT(Tin,'descend');
        switch clusterOp
            case 1        
                Tin=cluster(ZYD,'maxclust',clusterS(3));
                color = ZYD(end-clusterS(3)+2,3)-eps;              
                cn(3)=clusterS(3);
            case 2
                Tin=cluster(ZYD,'cutoff',cutoff(3));
                cn(3)=length(unique(Tin));
                color = ZYD(end-cn(3)+2,3)-eps;
                
        end
 subplot(1,3,3)
 hden3=dendrogram(ZYD, 0, 'colorthreshold', color,'labels',num2str(sort(M.Data.Sort.vGlom)));
        T(:,3)=rearrangeT(Tin,'descend');
    
        Tarr=T;
            for i=1:cn(1)
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

            %set cluster colors by calculating the distribution of color
            %among groups
        clusterColor=zeros(G,3);            
            Tarr1n=max(Tarr(:,1));
            clusterColor(:,1)=round(Tarr(:,1)/Tarr1n); modr=mod(Tarr(:,1),Tarr1n);
            clusterColor(:,2)=round(modr(:,1)*2/Tarr1n)/Tarr1n*2; modg=mod(modr(:,1),Tarr1n/2);
            clusterColor(:,3)=round(modg(:,1)*4/Tarr1n);


            
        clusterColor1=zeros(G,3);
            Tarr1n2=max(Tarr(:,2));
            clusterColor1(:,1)=round(Tarr(:,2)/Tarr1n2); modr1=mod(Tarr(:,2),Tarr1n2);
            clusterColor1(:,2)=round(modr1(:,1)*2/Tarr1n2)/Tarr1n2*2; modg1=mod(modr1(:,1),Tarr1n2/2);
            clusterColor1(:,3)=round(modg1(:,1)*4/Tarr1n2);    
    
        clusterColor2=zeros(G,3);
            Tarr1n3=max(Tarr(:,3));
            clusterColor2(:,1)=round(Tarr(:,3)/Tarr1n3); modr2=mod(Tarr(:,3),Tarr1n3);
            clusterColor2(:,2)=round(modr2(:,1)*2/Tarr1n3)/Tarr1n3*2; modg2=mod(modr2(:,1),Tarr1n3/2);
            clusterColor2(:,3)=round(modg2(:,1)*4/Tarr1n3);   
            
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
        Z=clusterColor;
        Z = con999(Z);
Z1=Z;     
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k');        set(gcf,'Color','w')
        xlim([0 max(X)]);        ylim([0 max(Y)])
            im=getframe;
            ClustImage1= frame2im(im);    %Return associated image data Truecolor system
        ClustImageBlurred1 = imfilter(ClustImage1,PSF,'circular','conv');
        title({PlotTitle;strcat('Hierarchical Cluster/',M.Project.Folder)},'FontSize',tFS)
    
    subplot(2,3,4)
        imagesc(ClustImageBlurred1);

    subplot(2,3,2)
        Z=abs(clusterColor-clusterColor1/3);
        Z = con999(Z);
Z2=Z;        
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k'); 
        xlim([0 max(X)]);        ylim([0 max(Y)])
            im=getframe;
            ClustImage2= frame2im(im);    %Return associated image data 
        ClustImageBlurred2 = imfilter(ClustImage2,PSF,'circular','conv');
    subplot(2,3,5)
        imagesc(ClustImageBlurred2);

    subplot(2,3,3)
        Z=abs(clusterColor-clusterColor1/3-clusterColor2/3);
        Z = con999(Z);
Z3=Z;        
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled'), axis ij
        set(gca,'Color','k'); 
        xlim([0 max(X)]);        ylim([0 max(Y)])
            im=getframe(gca);
            ClustImage3= frame2im(im);    %Return associated image data 
        ClustImageBlurred3 = imfilter(ClustImage3,PSF,'circular','conv');
    subplot(2,3,6)
        imagesc(ClustImageBlurred3);

MakeColorConsistent(hden1,Z1);        
MakeColorConsistent(hden2,Z2);        
MakeColorConsistent(hden3,Z3);        


function RGB2 = con999(RGB1)
% convert [1 1 0] to [60 92 170]/255
RGB2 = RGB1;
for i=1:size(RGB1,1)
    if RGB1(i,1)==1 &&  RGB1(i,2)==1 && RGB1(i,3)==0
        RGB2(i,1) = 60/255;
        RGB2(i,2) = 92/255;
        RGB2(i,3) = 170/255;
    end
end
