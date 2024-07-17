function AllPlotGlomSimMap(M)

%Call PlotGlomSimMap function to plot all stat options for cluster analysis
% with 5, 10, and 15 clusters;
%save the plots in 'C:/GIA/',M.Project.Folder,'/Analysis/SpatialMaps'


% Check for Spacial Map Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis/SpatialMaps'),'dir'),7)

else
    mkdir(fullfile(M.Project.Folder,'Analysis'),'SpatialMaps')
end

ProjectName = M.Project.Info{1,2};

clusterN=[3 6 18];
StatsOption=['EuclideanDistance'; 
             'NormDotProduct   '; 
             'Normalizedranks  '];
Option=cellstr(StatsOption);
FilePath2=fullfile(M.Project.Folder,'Analysis/SpatialMaps');
for i=1:length(clusterN)
    for j=1:3
      PlotGlomSimMap(M,j,clusterN(i)); 
      filenamej=strcat(ProjectName,'-GlomSimMap',Option(j),'cluster-',num2str(clusterN(i)));
      saveas(gcf,strcat(FilePath2,'/',cell2mat(filenamej),'.fig'))
      print('-cmyk','-djpeg','-f1',strcat(FilePath2,'/',cell2mat(filenamej),'.jpg'))
      close
    end;
end;
PlotGlomSimMapMulti6(M,2,[3 6 18])
      filenamej=strcat(ProjectName,'-GlomSimMapAll');
      saveas(gcf,strcat(FilePath2,'/',filenamej,'.fig'))
      print('-cmyk','-djpeg','-f1',strcat(FilePath2,'/',filenamej,'.tif'))
      close
close

