function PlotTemporalIntensityHeatMaps(M)
%addpath('../plotting')

[T G C O]=size(M.Data.Sort.MM);

% Plot Font Size Settings
tFS=30;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
if T>=60
    FV=5:60;   % Frame Vector
else
    FV=5:T;
end

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
% Check for Temporal Intensity Folder
% if isequal(exist(fullfile(M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity'),'dir'),7)
%     rmdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity'),'s')
%     mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'TemporalIntensity')
%     mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity'),'Odorant')
%     mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity'),'Glomeruli')
% else
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps'),'TemporalIntensity')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity'),'Odorant')
    mkdir(fullfile(M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity'),'Glomeruli')
% end

MM=permute(M.Data.Sort.MM,[3 2 4 1]);       % [Conc Glomeruli Odor Time]
Cmax=max(max(max(max(MM))));

figure ('position',[30 30 400 360])
for i=1:sum(M.Data.Sort.aOdor)
    o=M.Data.Sort.vOdor(i);
    for j=1:length(FV)
        t=FV(j);
        imagesc(MM(:,:,i,t),[0 Cmax]);        colorbar;
        title(strcat(cell2mat(M.Experiment.Odor.Name(o)),'-F',num2str(t)),'FontSize',tFS)
        xlabel('Glomerulus Number','FontSize',xFS)
        ylabel('Concentration Number','FontSize',yFS)
        Mov(j)=getframe(gcf);
    end

        filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity/Odorant');
        filename=strcat('Odor',num2str(i),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Intensity-HeatMap.avi');
        aviFileName = fullfile(filepath,filename);
        display(aviFileName);
        movie2avi(Mov,aviFileName);
%        display(strcat(filename))
end
close;
clear Mov MM;

MM=permute(M.Data.Sort.MM,[3 4 2 1]);       % [Conc Odor Glomeruli Time]
figure ('position',[30 30 400 360])
for i=1:sum(M.Data.Sort.aGlom)
    for j=1:length(FV)
        t=FV(j);
        g=M.Data.Sort.vGlom(i);
        imagesc(MM(:,:,i,t),[0 Cmax]);colorbar
        title(strcat('Glomerulus-',int2str(i),'-F',num2str(t)),'FontSize',tFS)
        xlabel('Odorant Number','FontSize',xFS)
        ylabel('Concentration Number','FontSize',yFS)
        Mov(j)=getframe(gcf);
    end  
        filepath=fullfile(M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity/Glomeruli');
        filename=strcat('G',num2str(i),'-Intensity-HeatMap.avi');
        movie2avi(Mov,fullfile(filepath,filename))
%        display(strcat(filename))

end
close