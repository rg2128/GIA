function Mov=DynamicHeatMap(M,GlomN,Tv)
%generate a movie sequence of dynamic change in tuning
%GlomN specific which glomerulus to plot.
%Tv is a vector indicating the frame numbers to be used for the movie


% Temporary: Add all function paths

%addpath('../plotting')

%[T G C O]=size(M.Data.Sort.MM);
% 
% % Plot Font Size Settings
% tFS=16;     % Title font size
% xFS=12;     % Y axis font size
% yFS=12;     % X axis font size
% %Tv=1:8:T;   % Frame Vector

MM=permute(M.Data.Sort.MM,[3 4 2 1]);       % [Conc Odor Glomeruli Time]
Cmax=max(max(max(max(MM))));
g=M.Data.Sort.vGlom(GlomN);

figure ('position',[30 30 400 360])
% title(strcat(M.Project.Folder,'Glomerulus-',int2str(GlomN),'-F',num2str(t)),'FontSize',tFS)
% xlabel('Odorant Number','FontSize',xFS)
% ylabel('Concentration Number','FontSize',yFS)

    for j=1:length(Tv)
        t=Tv(j);
        A=(MM(:,:,g,t));
        imagesc(A,[0 Cmax]);colormap jet
        Mov(j) = getframe;
    end

%close