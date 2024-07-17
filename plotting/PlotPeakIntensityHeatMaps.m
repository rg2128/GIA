function PlotPeakIntensityHeatMaps(M)
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
% Check for Peak Intensity Folder
if isequal(exist(fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity'),'dir'),7)
    rmdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity'),'s')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'PeakIntensity')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity'),'Odorant')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity'),'Glomeruli')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity'),'Concentration')
else
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'PeakIntensity')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity'),'Odorant')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity'),'Glomeruli')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity'),'Concentration')
end

[C G O]=size(M.Data.Sort.Peak);
Cmax=max(max(max(M.Data.Sort.Peak)));
Omax=sum(M.Data.Sort.aOdor)*interpN^2;
Concmax=sum(M.Data.Sort.aConc)*interpN^2;
Gmax=sum(M.Data.Sort.aGlom)*interpN^2;
Peak=M.Data.Sort.Peak;

figure
    odorlist = M.Data.Sort.vOdor;
    glomlist = M.Data.Sort.vGlom;
    conclist= find(M.Data.Sort.aConc==1);% changed in 9/2/2010 coz no vConc    
for i=1:O

    o=M.Data.Sort.vOdor(i);
    
    imagesc(Peak(:,:,i),[0 Cmax]);colorbar;
%     colormap(gray);
    title(cell2mat(M.Experiment.Odor.Name(M.Data.Sort.vOdor(i))),'FontSize',tFS)
    xlabel('Glomerulus Number','FontSize',xFS)
    ylabel('Concentration Number','FontSize',yFS)
    filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity/Odorant');
    filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Intensity-HeatMap.jpg');
    print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
    filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Intensity-HeatMap.fig');
    saveas(gcf,fullfile(filepath,filename));
    display(strcat(filename))
    

    %imagesc(Peak(:,:,i));
        %added and changed by ron 09-08-10
    A=(Peak(:,:,i));
    if min(size(A))>=2
        B=interp2(A,interpN,'spline');
        surf(B,'EdgeColor','none'); axis off
        view(gca,[-30 20]);
        axis([0 Gmax 0 Concmax 0 Cmax]);
        title(cell2mat(M.Experiment.Odor.Name(o)),'FontSize',tFS)
        xlabel('Glomerulus Number','FontSize',xFS)
        ylabel('Concentration Number','FontSize',yFS)
        caxis([0 Cmax])
        colorbar;
%         colormap(gray);
        filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity/Odorant');
        filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Intensity-3DHeatMap.jpg');
        print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
        filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Intensity-3DHeatMap.fig');
        saveas(gcf,fullfile(filepath,filename));
        display(strcat(filename))
    else
        continue
    end
    

end

Peak=permute(M.Data.Sort.Peak,[1 3 2]);

for i=1:G
    
    imagesc(Peak(:,:,i),[0 Cmax]); colorbar;
%     colormap(gray)
    title(strcat('Glomerulus-',int2str(glomlist(i))),'FontSize',tFS)
    xlabel('Odorant Number','FontSize',xFS)
    ylabel('Concentration Number','FontSize',yFS)
    filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity/Glomeruli');
    filename=strcat('G',num2str(glomlist(i)),'-Intensity-HeatMap.jpg');
    print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
    filename=strcat('G',num2str(glomlist(i)),'-Intensity-HeatMap.fig');
    saveas(gcf,fullfile(filepath,filename));
    display(strcat(filename))
    

        %added and changed by ron 09-08-10
    %imagesc(Peak(:,:,i));
    A=(Peak(:,:,i));
    if min(size(A))>=2
        B=interp2(A,interpN,'spline');
        surf(B,'EdgeColor','none'); axis off
        view(gca,[-30 20]);
        axis([0 Omax 0 Concmax 0 Cmax]);
        title(strcat('Glomerulus-',int2str(glomlist(i))),'FontSize',tFS)
        xlabel('Odorant Number','FontSize',xFS)
        ylabel('Concentration Number','FontSize',yFS)
        caxis([0 Cmax])
        colorbar
%         colormap(gray);
        filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity/Glomeruli');
        filename=strcat('G',num2str(glomlist(i)),'-Intensity-3DHeatMap.jpg');
        print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename));
        filename=strcat('G',num2str(glomlist(i)),'-Intensity-3DHeatMap.fig');
        saveas(gcf,fullfile(filepath,filename));
        display(strcat(filename))
    else
        continue
    end
    

end

Peak=permute(M.Data.Sort.Peak,[3 2 1]);

for i=1:C

    imagesc(Peak(:,:,i));
    title(strcat('Concentration-',int2str(conclist(i))),'FontSize',tFS)
    xlabel('Glomerulus Number','FontSize',xFS)
    ylabel('Odorant Number','FontSize',yFS)
    caxis([0 Cmax])
    colorbar
%     colormap(gray);
    filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/PeakIntensity/Concentration');
    filename=strcat('C',num2str(conclist(i)),'-Intensity-HeatMap.jpg');
    print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
    filename=strcat('C',num2str(conclist(i)),'-Intensity-HeatMap.fig');
    saveas(gcf,fullfile(filepath,filename));
    display(strcat(filename))
end
    
close