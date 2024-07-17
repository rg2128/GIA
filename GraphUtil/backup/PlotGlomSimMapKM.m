%calculating similarity in receptive field among glomeruli, plot the
%similary onto physical map. 
%
%The function take the form
%T=PlotGlomSimMap(M,option,clusterN,cutoff)
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

function [IDX C]=PlotGlomSimMapKM(M,option,clusterN)

if nargin<3

    clusterN=5;
end

if nargin<2
    clusterN=5;
    option=2;
end

addpath('../plotting')
    
Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
Peak=Peak(:,:);                         %make odor/conc into a single dimension

switch option
    case 1
        [IDX C]=kmeans(Peak,clusterN,'distance','sqEuclidean'); %calculating using Euclidean Distance
        PlotTitle='Euclidean Distance Similarity Plot';
    case 2
        [IDX C]=kmeans(Peak,clusterN,'distance','correlation'); %calculating using Euclidean Distance
        PlotTitle='Correlation Similarity Plot';
end

Z=IDX;

 % Plot Font Size Settings
tFS=15;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
MS=200;      % Marker Size       
        
Lx=cell2mat(M.Project.ROI(3));              % X pixel #
Ly=cell2mat(M.Project.ROI(3));              % Y pixel #
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
S=zeros(sum(M.Data.Sort.aGlom),1)+MS;       % Marker Size vector                       
X=linspace(0,(Lx-1)*SF,Lx);                 % X axis length vector
Y=linspace(0,(Ly-1)*SF,Ly);                 % Y axis length vector
ROI=FlipROI(M);
ROIx=ROI(M.Data.Sort.vGlom,1);              % Sorted ROI x coordinates
ROIy=ROI(M.Data.Sort.vGlom,2);              % Sorted ROI y coordinates


% %set number of subplots
% rown=floor(sqrt(clusterN));
% if rown^2==clusterN
%     coln=rown;
% else if rown*(rown+1)<clusterN
%         coln=rown+2;
%     else
%         coln=rown+1;
%     end
% end

figure
        scatter(ROIx*SF,ROIy*SF,S,Z,'filled')
        set(gca,'Color',[0.2 0.2 0.2])
        set(gcf,'Color','w')
        set(gcf, 'InvertHardCopy', 'off');
        xlim([0 max(X)])
        ylim([0 max(Y)])
        title({PlotTitle;M.Project.Folder},'FontSize',tFS)
        xlabel('\mum','FontSize',xFS)
        ylabel('\mum','FontSize',yFS)
        axis ij
        colormap jet
        colorbar
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