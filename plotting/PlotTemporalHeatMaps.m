function PlotTemporalHeatMaps(M)
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
% Check for Temporal
if isequal(exist(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Temporal'),'dir'),7)
    rmdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Temporal'),'s')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'Temporal')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Temporal'),'Odorant')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Temporal'),'Glomeruli')
else
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'Temporal')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Temporal'),'Odorant')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Temporal'),'Glomeruli')
end

Cmax=max(max(max(M.Data.Sort.Sorted)));

figure
for i=1:sum(M.Data.Sort.aOdor)
    imagesc(M.Data.Sort.Sorted(:,:,i));
    title(cell2mat(M.Experiment.Odor.Name(M.Data.Sort.vOdor(i))),'FontSize',tFS)
    xlabel('Glomerulus Number','FontSize',xFS)
    ylabel('Frame','FontSize',yFS)
    caxis([0 Cmax])
    colorbar
    filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/Temporal/Odorant');
    filename=strcat('Odor',num2str(M.Data.Sort.vOdor(i)),'-',cell2mat(M.Experiment.Odor.Name(M.Data.Sort.vOdor(i))),'-Temporal-HeatMap.jpg');
    print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename));
    filename=strcat('Odor',num2str(M.Data.Sort.vOdor(i)),'-',cell2mat(M.Experiment.Odor.Name(M.Data.Sort.vOdor(i))),'-Temporal-HeatMap.fig');
    saveas(gcf,fullfile(filepath,filename));
    display(strcat(filename))
end

Sorted=permute(M.Data.Sort.Sorted,[1 3 2]);

for i=1:sum(M.Data.Sort.aGlom)
    imagesc(Sorted(:,:,i));
    title(strcat('Glomerulus-',int2str(i)),'FontSize',tFS)
    xlabel('Odorant Number','FontSize',xFS)
    ylabel('Frame','FontSize',yFS)
    caxis([0 Cmax])
    colorbar
    filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/Temporal/Glomeruli');
    filename=strcat('G',num2str(M.Data.Sort.vGlom(i)),'-Temporal-HeatMap.jpg');
    print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename));
    filename=strcat('G',num2str(M.Data.Sort.vGlom(i)),'-Temporal-HeatMap.fig');
    saveas(gcf,fullfile(filepath,filename));
    display(strcat(filename))
end
close