function PlotTemporalIntensityHeatMapsOld(M)
addpath('../plotting')

[T G C O]=size(M.Data.Sort.MM);

% Plot Font Size Settings
tFS=30;     % Title font size
xFS=20;     % Y axis font size
yFS=20;     % X axis font size
FV=5:60;   % Frame Vector



MM=permute(M.Data.Sort.MM,[3 2 4 1]);       % [Conc Glomeruli Odor Time]
Cmax=max(max(max(max(MM))));

figure('Position',[30 30 400 360])
for i=1:sum(M.Data.Sort.aOdor)
    o=M.Data.Sort.vOdor(i);
    for j=1:length(FV)
        t=FV(j);
        imagesc(MM(:,:,i,t),[0 Cmax]);        colorbar;
        title(strcat(cell2mat(M.Experiment.Odor.Name(o)),'-F',num2str(t)),'FontSize',tFS)
        xlabel('Glomerulus Number','FontSize',xFS)
        ylabel('Concentration Number','FontSize',yFS)
        Mov(j)=getframe;
    end

        filepath=strcat('C:/GIA/',M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity/Odorant');
        filename=strcat('Odor',num2str(i),'-',cell2mat(M.Experiment.Odor.Name(o)),'-Intensity-HeatMap.avi');
        movie2avi(Mov,strcat(filepath,'/',filename),'compression','Indeo5')
        display(strcat(filename))    
end
close

MM=permute(M.Data.Sort.MM,[3 4 2 1]);       % [Conc Odor Glomeruli Time]
figure('Position',[30 30 400 360])
for i=1:sum(M.Data.Sort.aGlom)
    for j=1:length(FV)
        t=FV(j);
        g=M.Data.Sort.vGlom(i);
        imagesc(MM(:,:,i,t),[0 Cmax]);colorbar
        title(strcat('Glomerulus-',int2str(i),'-F',num2str(t)),'FontSize',tFS)
        xlabel('Odorant Number','FontSize',xFS)
        ylabel('Concentration Number','FontSize',yFS)

    end  
        filepath=strcat('C:/GIA/',M.Project.Folder,'/Analysis/HeatMaps/TemporalIntensity/Glomeruli');
        filename=strcat('G',num2str(g),'-Intensity-HeatMap.avi');
        movie2avi(Mov,strcat(filepath,'/',filename),'compression','Indeo5')
        display(strcat(filename))    
end

close