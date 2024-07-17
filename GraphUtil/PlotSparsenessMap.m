
% Plot Font Size Settings
tFS=30;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
MS=200;     % Marker Size

[C G O]=size(M.Data.Analysis.Sparse.Glom);
Lx=cell2mat(M.Project.ROI(3));              % X pixel #
Ly=cell2mat(M.Project.ROI(3));              % Y pixel #
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
S=zeros(sum(M.Data.Sort.aGlom),1)+MS;       % Marker Size vector                       
X=linspace(0,(Lx-1)*SF,Lx);                 % X axis length vector
Y=linspace(0,(Ly-1)*SF,Ly);                 % Y axis length vector
ROI=FlipROI(M);
ROIx=ROI(M.Data.Sort.vGlom,1);       % Sorted ROI x coordinates
ROIy=ROI(M.Data.Sort.vGlom,2);        % Sorted ROI y coordinates
Glom=M.Data.Analysis.Sparse.Glom;           % Sparseness Matrix

    figure('position', [30 30 1200 300])
for i=5:8
    subplot(1,4,i-4)
    c=M.Data.Sort.vConc(i);
    scatter(ROIx*SF,ROIy*SF,S,Glom(i,:),'filled')
    set(gca,'Color',[0.2 0.2 0.2])
    set(gcf,'Color','w')
    title(strcat('Glomerulus Sparsness - C',num2str(c)),'FontSize',tFS)
    xlabel('\mum','FontSize',xFS)
    ylabel('\mum','FontSize',yFS)
    xlim([0 max(X)])
    ylim([0 max(Y)])
    caxis([0 1])
    axis ij
end

figure
GlomA=M.Data.Analysis.Sparse.GlomAll; 

    scatter(ROIx*SF,ROIy*SF,S,GlomA(i,:),'filled')
    set(gca,'Color',[0.2 0.2 0.2])
    set(gcf,'Color','w')
    title('Glomerulus Sparsness - All Conc','FontSize',tFS)
    xlabel('\mum','FontSize',xFS)
    ylabel('\mum','FontSize',yFS)
    xlim([0 max(X)])
    ylim([0 max(Y)])
    caxis([0 1])
    axis ij