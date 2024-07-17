function PlotAllSpatialandHeatmaps(M)


if isequal(exist(fullfile(M.Project.Folder,'Analysis'),'dir'),7)
else
    mkdir(M.Project.Folder,'Analysis')
end
% Check for Heat Map Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis/HeatMaps'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'Analysis'),'HeatMaps')
end
% Check for Spatial Map Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis/SpatialMaps'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'Analysis'),'SpatialMaps')
end


%set file path
PathName1=fullfile(M.Project.Folder,'Analysis/Stats');
PathName2=fullfile(M.Project.Folder,'Analysis/SpatialMaps');

ProjectName = M.Project.Info{1,2};  
% % 
% % plot all Heatmaps
% PlotTuningHeatMaps(M);
% 
% %plot every 8 frames heatmap and saved in TemporalIntensity folder
% %PlotTemporalIntensityHeatMaps(M);
% 
% 
% %plot temporal map and save in Temporal folder
% % PlotTemporalHeatMaps(M);
% 
% %plot PeakIntensity and save in Peak Intensity folder
% PlotPeakIntensityHeatMaps(M);
% % 
% %Plot Sparseness Matrix and save in Heatmap/Sparse
% PlotSparseMatrix(M);
% 
% 
% 
% PlotFieldMapResp(M)
%     filenamej=strcat(ProjectName,'-AllFieldMapResp');
%     print('-cmyk','-djpeg','-f1',strcat(PathName2,'/',filenamej, '.jpg'));
%     saveas(gcf,strcat(PathName2,'/',filenamej, '.fig'));
%     close
%     
%     
% PlotFieldMapRespRankNormalized(M)
%     filenamej=strcat(ProjectName,'-AllFieldMapRespRankNormalized');
%     print('-cmyk','-djpeg','-f1',strcat(PathName2,'/',filenamej,'.jpg'));
%     saveas(gcf,strcat(PathName2,'/',filenamej,'.fig'));
% 
%     close
%  
%     
% % Plot Peak Intensity map and save in /SpatialMaps/Field/PeakIntensity folder
% 
% AllPlotGlomSimMap(M);
% 
% PlotMarkerPeakIntensitySpatialMaps(M);
% PlotMarkerSparseSpatialMaps(M);
PlotFieldPeakIntensitySpatialMaps(M);

































% 
% 
% C=sum(M.Data.Sort.aConc);
% I=PeakPCAM(M);
% 
% for option=1:4
%     PlotPeakPCA(I,option,0,1:C)
%     filename=strcat(M.Project.Folder,'-',num2str(option),'-PCA.fig');
%     print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filename))
%     filenamej=strcat(M.Project.Folder,'-',num2str(option),'-PCA.jpg');
%     print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filenamej));
%     close
% end
% for option=1:5
%     plotCluster(M,option)
%     filename=strcat(M.Project.Folder,'-',num2str(option),'-cluster.fig');
%     print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filename))
%     filenamej=strcat(M.Project.Folder,'-',num2str(option),'-cluster.jpg');
%     print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filenamej))
%     close
% end
% for option=1:5
%     plotClusterOnly(M,option)
%     filename=strcat(M.Project.Folder,'-',num2str(option),'-OdorDendrogram.fig');
%     print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filename))
%     filenamej=strcat(M.Project.Folder,'-',num2str(option),'-OdorDendrogram.jpg');
%     print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filenamej))
%     close
% end
%     
% 
% function I=PeakPCAM(M)
% Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
% Peak=Peak(:,:);                    %make odor/conc into a single dimension
% O=sum(M.Data.Sort.aOdor);
% C=sum(M.Data.Sort.aConc);
% rOdorAbr=M.Experiment.Odor.Abr(M.Data.Sort.vOdor);
% origlabel=cell(O*C,1);
% for i=1:O
%     for j=1:C
%         origlabel((i-1)*C+j)=strcat(rOdorAbr(i),num2str(j));
%     end
% end
% 
% Odors.O=O;
% Odors.C=C;
% Odors.Abr=rOdorAbr;
% Odors.label=origlabel;
% 
% zPeak=Peak;
% [coefs,scores]=princomp(zPeak');
% PCAdata.Peakdata.coefs=coefs;
% PCAdata.Peakdata.scores=scores;
% 
% zPeak=zscore(Peak);
% [coefs,scores]=princomp(zPeak');
% PCAdata.PeakZScore.coefs=coefs;
% PCAdata.PeakZScore.scores=scores;
% 
% zPeak=normr(Peak);
% [coefs,scores]=princomp(zPeak');
% PCAdata.PeakNorm.coefs=coefs;
% PCAdata.PeakNorm.scores=scores;
% 
% zPeak=normr(Peak);
% zPeak=tiedrank(zPeak);
% [coefs,scores]=princomp(zPeak');
% PCAdata.PeakRank.coefs=coefs;
% PCAdata.PeakRank.scores=scores;
% 
% I.Odors=Odors;
% I.PCAdata=PCAdata;
% 
% save(strcat('C:/GIA/',M.Project.Folder,'/','PCAdata.mat'));