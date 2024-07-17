function PlotFieldPeakIntensitySpatialMaps(M)
% Plot Font Size Settings
tFS=30;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size

% Check for Analysis Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder),'Analysis')
end
% Check for Spatial Map Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis/SpatialMaps'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'Analysis'),'SpatialMaps')
end
% Check for Field Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis/SpatialMaps/Field'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'Analysis/SpatialMaps'),'Field')
end
% Check for Peak Intensity Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis/SpatialMaps/Field/PeakIntensity'),'dir'),7)
    rmdir(fullfile(M.Project.Folder,'Analysis/SpatialMaps/Field/PeakIntensity'),'s')
end   
mkdir(fullfile(M.Project.Folder,'Analysis/SpatialMaps/Field'),'PeakIntensity')

    conclist= find(M.Data.Sort.aConc==1);%added 9/2/2010

for i=1:sum(M.Data.Sort.aConc)
    c=conclist(i);
    foldername=strcat('Concentration-',num2str(c));
    mkdir(fullfile(M.Project.Folder,'Analysis/SpatialMaps/Field/PeakIntensity'),foldername)
end


Cmax=max(max(max(M.Data.Sort.Peak)));

figure
for i=1:sum(M.Data.Sort.aOdor)
    o=M.Data.Sort.vOdor(i);
    for j=1:sum(M.Data.Sort.aConc)
        c=conclist(j);
        [X Y A]=ROIfield(M,M.Data.Sort.Peak(j,:,i),1);
        imagesc(X,Y,A);
        title(cell2mat(M.Experiment.Odor.Name(o)),'FontSize',tFS)
        xlabel('\mum','FontSize',xFS)
        ylabel('\mum','FontSize',yFS)
        caxis([0 Cmax])
%         colormap copper
        colorbar; 
        foldername=strcat('Concentration-',num2str(c));
        filepath=fullfile(M.Project.Folder,'Analysis/SpatialMaps/Field/PeakIntensity',foldername);
        filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Conc',num2str(c),'-Intensity-Field-SpatialMap.jpg');
        print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
        filename2=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Conc',num2str(c),'-Intensity-Field-SpatialMap.fig');
        saveas(gcf,strcat(filepath, '/',filename2));
        display(strcat(filename))
    end
end

close