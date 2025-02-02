function PlotMarkerPeakIntensitySpatialMaps(M)
% Plot Font Size Settings
tFS=30;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
MS=200      % Marker Size

% Check for Analysis Folder
if isequal(exist(fullfile(M.Project.Folder,'/Analysis'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder),'Analysis')
end
% Check for Spatial Map Folder
if isequal(exist(fullfile(M.Project.Folder,'/Analysis/SpatialMaps'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'/Analysis'),'SpatialMaps')
end
% Check for Marker Folder
if isequal(exist(fullfile(M.Project.Folder,'/Analysis/SpatialMaps/Marker'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'/Analysis/SpatialMaps'),'Marker')
end

conclist= find(M.Data.Sort.aConc==1);% added 9/2/2010
    
% Check for Peak Intensity Folder
if isequal(exist(fullfile(M.Project.Folder,'/Analysis/SpatialMaps/Marker/PeakIntensity'),'dir'),7)
    rmdir(fullfile(M.Project.Folder,'/Analysis/SpatialMaps/Marker/PeakIntensity'),'s')
    mkdir(fullfile(M.Project.Folder,'/Analysis/SpatialMaps/Marker'),'PeakIntensity')
    for i=1:sum(M.Data.Sort.aConc)
        c=conclist(i);
        foldername=strcat('Concentration-',num2str(c));
        mkdir(fullfile(M.Project.Folder,'/Analysis/SpatialMaps/Marker/PeakIntensity'),foldername)
    end
else
    mkdir(fullfile(M.Project.Folder,'/Analysis/SpatialMaps/Marker'),'PeakIntensity')
    for i=1:sum(M.Data.Sort.aConc)
        c=conclist(i);
        foldername=strcat('Concentration-',num2str(c));
        mkdir(fullfile(M.Project.Folder,'/Analysis/SpatialMaps/Marker/PeakIntensity'),foldername)
    end
end

Lx=cell2mat(M.Project.ROI(3));              % X pixel #
Ly=cell2mat(M.Project.ROI(3));              % Y pixel #
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
S=zeros(sum(M.Data.Sort.aGlom),1)+MS;       % Marker Size vector                       
X=linspace(0,(Lx-1)*SF,Lx);                 % X axis length vector
Y=linspace(0,(Ly-1)*SF,Ly);                 % Y axis length vector
ROI=FlipROI(M);
ROIx=ROI(M.Data.Sort.vGlom,1);       % Sorted ROI x coordinates
ROIy=ROI(M.Data.Sort.vGlom,2);        % Sorted ROI y coordinates
Peak=M.Data.Sort.Peak;                      % Peak Intensity
Cmax=max(max(max(Peak)));                   % Data set Max

figure
for i=1:sum(M.Data.Sort.aOdor)
    o=M.Data.Sort.vOdor(i);
    for j=1:sum(M.Data.Sort.aConc)
        c=conclist(j);
        scatter(ROIx*SF,ROIy*SF,S,Peak(j,:,i),'filled')
        set(gca,'Color',[0.2 0.2 0.2])
        set(gcf,'Color','w')
        set(gcf, 'InvertHardCopy', 'off');
        xlim([0 max(X)])
        ylim([0 max(Y)])
        title(cell2mat(M.Experiment.Odor.Name(o)),'FontSize',tFS)
        xlabel('\mum','FontSize',xFS)
        ylabel('\mum','FontSize',yFS)
        caxis([0 Cmax])
        axis ij
        colorbar
        foldername=strcat('Concentration-',num2str(c));
        filepath=fullfile(M.Project.Folder,'/Analysis/SpatialMaps/Marker/PeakIntensity/',foldername);
        filename=strcat('Odor',num2str(o),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Conc',num2str(c),'-Intensity-Marker-SpatialMap.jpg');
        print('-cmyk','-djpeg','-f1',strcat(filepath,'/',filename))
        display(strcat(filename))
    end
end

close