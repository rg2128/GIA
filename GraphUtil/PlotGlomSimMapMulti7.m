function SimMatrix=PlotGlomSimMapMulti7(M,option,clusterS,GaussForm)
%% following comments are from a previous version
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
%
%% modified by Elden Yu @ 7/19/2010
%  to have consistent colors in the two types of graphs
%  1. changed NormDotProduct to pdist(X,'cosine')
%  2. 
%  incomplete, to be continued...

addpath('../plotting')
if nargin<4
    GaussForm.A=[20 20];GaussForm.Se=3;   
end
if nargin<3
    clusterS=[3 6 9];
end
if nargin<2
    option=2;
end
if nargin<1
    M = load('c:\GIA\project11\Project.mat');    
end

%%
cc=max(clusterS);
if cc<=2
    cutoff=clusterS; % the same parameter means cutoff
    clusterOp=2;
else
    clusterOp=1;
end


%% get peak information   
Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
Peak=Peak(:,:);                         %make odor/conc into a single dimension

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

%% storage for clustering results
G=sum(M.Data.Sort.aGlom);
T=zeros(G,length(clusterS));
cn=zeros(1,length(clusterS));
hden = cell(1,length(clusterS));
ZZ = cell(1,length(clusterS));

%% plot 1
SimMatrix=1-squareform(YD);
figure
imagesc(SimMatrix);

%% plot 2
figure('position',[5 5 1200 400])
for i=1:length(clusterS)
    switch clusterOp
        case 1 % mostly 1st run, use max cluster 
            T(:,i) = cluster(ZYD,'maxclust',clusterS(i));
            color = ZYD(end-clusterS(i)+2,3)-eps;
        case 2 % use cutoff for later runs
            T(:,i) = cluster(ZYD,'cutoff',cutoff(i),'criterion','distance');
            color = cutoff(i);
    end
    cn(i)=length(unique(T));
    
    subplot(1,length(clusterS),i);
    hden{i} = dendrogram(ZYD, 0, 'colorthreshold', color,'labels',num2str(sort(M.Data.Sort.vGlom)));
    set(hden{i},'LineWidth',2);
end

if clusterOp==1
    disp('get cutoff values from the dendrograms and run again');
    return;
end
    
%% prepare plot 3         
% Plot Font Size Settings
tFS=15;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
MS=300;      % Marker Size       
%set ROI indices     
Lx=cell2mat(M.Project.ROI(3));              % X pixel #
Ly=cell2mat(M.Project.ROI(4));              % Y pixel #
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
S=ones(G,1)*MS;       % Marker Size vector                       
X=linspace(0,(Lx-1)*SF,Lx);                 % X axis length vector
Y=linspace(0,(Ly-1)*SF,Ly);                 % Y axis length vector
ROI = ROI2apml(M.Data.ROI,M.Project.ROI);
ROIx=SF*ROI(M.Data.Sort.vGlom,1);              % Sorted ROI x coordinates
ROIy=SF*ROI(M.Data.Sort.vGlom,2);              % Sorted ROI y coordinates
%set point spread function using structure GaussForm
PSF = fspecial('gaussian',GaussForm.A,GaussForm.Se);

%% plot 3
figure('position',[5 5 1500 1000]);
for i=1:length(clusterS)
    subplot(2,length(clusterS),i);
%    Z = ChooseColor(ROI,T(:,i));
    Z = ChooseColor2(T(:,i),i);
    ZZ{i} = Z;
    scatter(ROIx,ROIy,S,Z,'filled'), axis ij
    set(gca,'Color','k');
    set(gcf,'Color','w')
    xlim([0 max(X)]);        
    ylim([0 max(Y)]);
    im=getframe;
    ClustImage= frame2im(im);    %Return associated image data Truecolor system
    ClustImageBlurred = imfilter(ClustImage,PSF,'circular','conv');
    title({PlotTitle;strcat('Hierarchical Cluster/',M.Project.Folder)},'FontSize',tFS);
    
    subplot(2,length(clusterS),length(clusterS)+i);
    imagesc(ClustImageBlurred);
end
MakeColorConsistent(hden{1},ZZ{1});        
MakeColorConsistent(hden{2},ZZ{2});        
MakeColorConsistent(hden{3},ZZ{3});        


