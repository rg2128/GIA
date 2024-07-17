function PlotSparseMatrix(M)
% Plot Font Size Settings
tFS=30;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size

% Check for Analysis Folder
if isequal(exist(fullfile(M.Project.Folder,'/Analysis'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder),'Analysis')
end
% Check for Heat Map Folder
if isequal(exist(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'/Analysis'),'HeatMaps')
end
% Check for Concentration
if isequal(exist(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Sparse'),'dir'),7)
    rmdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Sparse'),'s')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'Sparse')
else
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'Sparse')
end

figure
i=isnan(M.Data.Analysis.Sparse.Odor);
imagesc(M.Data.Analysis.Sparse.Odor,'AlphaData',(i*-1)+1);
set(gca,'Color','k')
set(gcf,'Color','w')
set(gcf, 'InvertHardCopy', 'off');
title('Odorant Sparseness Matrix','FontSize',tFS)
xlabel('Odorant Number','FontSize',xFS)
ylabel('Concentration Number','FontSize',yFS)
caxis([0 1])
colorbar
filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/Sparse');
filename=strcat('Odorant-Sparse-HeatMap.jpg');
print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
filename=strcat('Odorant-Sparse-HeatMap.fig');
saveas(gcf,fullfile(filepath,filename));
display(strcat(filename))

i=isnan(M.Data.Analysis.Sparse.Glom);
imagesc(M.Data.Analysis.Sparse.Glom,'AlphaData',(i*-1)+1);
set(gca,'Color','k')
set(gcf,'Color','w')
set(gcf, 'InvertHardCopy', 'off');
title('Glomerulus Sparseness Matrix','FontSize',tFS)
xlabel('Glomerulus  Number','FontSize',xFS)
ylabel('Concentration Number','FontSize',yFS)
caxis([0 1])
colorbar
filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/Sparse');
filename=strcat('Glomeruli-Sparse-HeatMap.jpg');
print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
filename=strcat('Glomeruli-Sparse-HeatMap.fig');
saveas(gcf,fullfile(filepath,filename));
display(strcat(filename))

close