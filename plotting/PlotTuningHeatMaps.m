function PlotTuningHeatMaps(M)
% Plot Font Size Settings
tFS=30;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
interpN=4;  % number of interpolation points
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
if isequal(exist(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning'),'dir'),7)
    rmdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning'),'s')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'Tuning')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning'),'Odorant')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning'),'Glomeruli')
else
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'Tuning')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning'),'Odorant')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning'),'Glomeruli')
end

Cmax=max(max(max(M.Data.Sort.Peak)));
Omax=sum(M.Data.Sort.aOdor)*interpN^2;
Concmax=sum(M.Data.Sort.aConc)*interpN^2;
Gmax=sum(M.Data.Sort.aGlom)*interpN^2;
figure

for i=1:sum(M.Data.Sort.aOdor)
    %added and changed by ron 09-08-10

    o= M.Data.Sort.vOdor(i);
    
    imagesc(M.Data.Analysis.Tuning.Odor(:,:,i),[0 Cmax]);colorbar;
%     colormap(gray);
    title(cell2mat(M.Experiment.Odor.Name(M.Data.Sort.vOdor(i))),'FontSize',tFS)
    xlabel('Glomerulus Number','FontSize',xFS)
    ylabel('Concentration Number','FontSize',yFS)
    filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning/Odorant');
    filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Tuning-HeatMap.jpg');
    print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
    filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Tuning-HeatMap.fig');
    saveas(gcf,fullfile(filepath,filename));
    display(strcat(filename))
    
    A=(M.Data.Analysis.Tuning.Odor(:,:,i));
    if min(size(A))>=2
        B=interp2(A,interpN,'spline');
        surf(B,'EdgeColor','none'); axis off
        view(gca,[-30 20]);
        axis([0 Gmax 0 Concmax 0 Cmax]);
        title(cell2mat(M.Experiment.Odor.Name(M.Data.Sort.vOdor(i))),'FontSize',tFS)
        xlabel('Glomerulus Number','FontSize',xFS)
        ylabel('Concentration Number','FontSize',yFS)
%         caxis([0 Cmax])
        colorbar;
%         colormap(gray);
        filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning/Odorant');
        filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-3DTuning-HeatMap.jpg');
        print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
        filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-3DTuning-HeatMap.fig');
        saveas(gcf,fullfile(filepath,filename));
        display(strcat(filename))
    else
        continue
    end
    

end

for i=1:sum(M.Data.Sort.aGlom)
    %added and changed by ron 09-08-10
    g= M.Data.Sort.vGlom(i);
    
    imagesc(M.Data.Analysis.Tuning.Glom(:,:,i),[0 Cmax]);colorbar;
%     colormap(gray);
    title(strcat('Glomerulus-',int2str(g)),'FontSize',tFS)
    xlabel('Odorant Number','FontSize',xFS)
    ylabel('Concentration Number','FontSize',yFS)
    filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning/Glomeruli');
    filename=strcat('G',num2str(g),'-Tuning-HeatMap.jpg');
    print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
    filename=strcat('G',num2str(g),'-Tuning-HeatMap.fig');
    saveas(gcf,fullfile(filepath,filename));
    display(strcat(filename))
    
    A=(M.Data.Analysis.Tuning.Glom(:,:,i));
    if min(size(A))>=2
        B=interp2(A,interpN,'spline');
        surf(B,'EdgeColor','none'); axis off
        view(gca,[-30 20]);
        axis([0 Omax 0 Concmax 0 Cmax]);
        title(strcat('Glomerulus-',int2str(g)),'FontSize',tFS)
        xlabel('Odorant Number','FontSize',xFS)
        ylabel('Concentration Number','FontSize',yFS)
%         caxis([0 Cmax])
        colorbar;
%         colormap(gray);
        filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/Tuning/Glomeruli');
        filename=strcat('G',num2str(g),'-3DTuning-HeatMap.jpg');
        print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
        filename=strcat('G',num2str(g),'-3DTuning-HeatMap.fig');
        saveas(gcf,fullfile(filepath,filename));
        display(strcat(filename))
    else
        continue
    end    

end
close