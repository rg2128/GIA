function PlotTemporalIntensityHeatMapsOnly(M,option,OGN,FV)

% get movie file for odor(option=0) or glomerulus(option=1) #OGN in the
% interval of FV

addpath('../plotting')

[T G C O]=size(M.Data.Sort.MM);

% Plot Font Size Settings
tFS=36;     % Title font size
xFS=30;     % Y axis font size
yFS=30;     % X axis font size
%FV=5:60;   % Frame Vector



       % [Conc Glomeruli Odor Time]
Cmax=max(max(max(max(M.Data.Sort.MM))));

%figure('Position',[30 30 960 360])
switch option
    case 0
    MM=permute(M.Data.Sort.MM,[3 2 4 1]);
    o=OGN;
    for j=1:length(FV)
        figure %subplot(1, length(FV), j)
        t=FV(j);
        imagesc(MM(:,:,o,t),[0 Cmax]);        %colorbar;
        set(gca,'FontSize',24,'FontWeight','Bold')
        %Mov(j)=getframe;
    
            title(strcat(cell2mat(M.Experiment.Odor.Name(M.Data.Sort.vOdor(o))),'-F',num2str(t)),'FontSize',tFS,'FontWeight','Bold')
        xlabel('Glomerulus','FontSize',xFS,'FontWeight','Bold')
        ylabel('Concentration Number','FontSize',yFS)
    end
    
    case 1

    MM=permute(M.Data.Sort.MM,[3 4 2 1]);       % [Conc Odor Glomeruli Time]


    for j=1:length(FV)
        figure
        t=FV(j);
        g=OGN;
        imagesc(MM(:,:,g,t),[0 Cmax]);colorbar
        set(gca,'FontSize',24,'FontWeight','Bold')

            title(strcat('Glomerulus-',int2str(g),'-F',num2str(t)),'FontSize',tFS,'FontWeight','Bold')
        xlabel('Odorant','FontSize',xFS,'FontWeight','Bold')
        ylabel('Concentration','FontSize',yFS,'FontWeight','Bold')
    end
end