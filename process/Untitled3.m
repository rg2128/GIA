function PlotCorrAwakeAnesth()
pdir1 = 'L:\Lab Member data files\Qiang\bulb imaging\GIAProccessed\GIA20110505-DRC-Awake\Response\all 10 odors with 7 concentration';          % Project1(awake/Response)
pdir2 = 'L:\Lab Member data files\Qiang\bulb imaging\GIAProccessed\GIA20110505-DRC-Anesth\Response\10 odors to match the awake';          % Project2(anesth/Valley)
Title = {'Corr of Awake vs Anesth'};
M1 = load(fullfile(pdir1,'Project.mat'));
M2 = load(fullfile(pdir2,'Project.mat'));

[C G O] = size(M1.Data.Sort.Peak);
Peak1 = zeros(1,C);
Peak2 = zeros(1,C);
OdorName = M1.Experiment.Odor.Name(M1.Data.Sort.vOdor);
GloName = M1.Data.Sort.vGlom;
CorrMatrix = [];
for i = 1:O
    for j = 1:G
        Peak1 = M1.Data.Sort.Peak(:,j,i);
        Peak2 = M2.Data.Sort.Peak(:,j,i);
        Corr = corr(Peak1,Peak2);
        CorrMatrix(i,j)= Corr;
    end
end
    figure; imagesc(CorrMatrix);
    colorbar;
    title(Title,'FontSize',20)
    set(gca,'XTick',1:size(M1.Data.Sort.vGlom));
    set(gca,'YTick',1:size(M1.Data.Sort.vOdor));
    set(gca,'XTickLabel',GloName); 
    set(gca,'YTickLabel',OdorName); 
    filename=strcat(pdir1,'\Corr-Awake-Anesth.fig');    
    saveas(gcf,filename);
end
    
