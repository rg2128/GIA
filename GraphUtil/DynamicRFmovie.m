function Mov=DynamicRFmovie(M,OGN,Tv,InterpN,OGswitch,viewpoint)
%generate a movie sequence of dynamic change in tuning
%OGN specific which glomerulus or Odor to plot.
%Tv is a vector indicating the frame numbers to be used for the movie
%InterpN is the number of points for interpolation
%OCswitch switches between plotting glomeruli and odor
%Default is glomerulus, OGswtich=1;
if nargin<6
    viewpoint=[330 20];
end
if nargin<5
    OGswitch=1;viewpoint=[330 20];
end
if nargin<4
    OGswitch=1;viewpoint=[330 20];
    InterpN=3;
end
if isequal(OGswitch,1)==false
        OGswitch=0;
end

% Temporary: Add all function paths
if exist('jet1.mat')==0
    mycmap=jet;
else
    load('jet1.mat','mycmap')
end

[T G C O]=size(M.Data.Sort.MM);
% 
% % Plot Font Size Settings
% tFS=30;     % Title font size
% xFS=20;     % Y axis font size
% yFS=20;     % X axis font size
% %Tv=1:8:T;   % Frame Vector

set(gcf,'Colormap',mycmap)
switch OGswitch
    case 1
        MM=permute(M.Data.Sort.MM,[3 4 2 1]);       % [Conc Odor Glomeruli Time]
        Cmax=max(max(max(max(MM)))); 
        if OGN>G || OGN<1
            g=G;
            display('Glomerulus Number Incorrect;ResetG')
        else
            g=OGN;
        end

        A=(MM(:,:,g,1));
        B=interp2(A,InterpN,'spline');
        [ymax xmax]=size(B);
        scalex=xmax/O;scaley=ymax/C;

    figure ('position',[30 30 400 360])

        for j=1:length(Tv)
            t=Tv(j);
            A=(MM(:,:,g,t));
            B=interp2(A,InterpN,'spline');
            surf(B,'EdgeColor','none');

            set(gcf,'Colormap',mycmap)
            axis([0 xmax 0 ymax 0 Cmax]);
            set(gca,'YTick',0:2*scaley:ymax,'YTickLabel',[0;2;4;6;8], ...
                'XTick',0:4*scalex:xmax,'xTickLabel',[0;4;8;12;16;20;24;28;32], ...
                'FontWeight','bold','CLimMode','manual','CLim',[0, Cmax],'LineWidth',2,'FontSize',12)
            view(gca,viewpoint);
            xlabel('Odors','FontWeight','bold','FontSize',16);
            ylabel('Conc','FontWeight','bold','FontSize',16);
            zlabel('\DeltaF/F','FontWeight','bold','FontSize',16);
            title(strcat(M.Project.Folder,'-Glomerulus-',int2str(g),'-F',num2str(t)),'FontWeight','bold','FontSize',16)
            Mov(j) = getframe(gcf);
        end
    case 0
        MM=permute(M.Data.Sort.MM,[3 2 4 1]);       % [Conc Glomeruli Odor Time]
        Cmax=max(max(max(max(MM))));

        if OGN>O || OGN<1
            display('Odor Number Incorrect;Reset O')
            o=O;
        else
            o=OGN;
        end
        %o=M.Data.Sort.vOdor(OGN);
            A=(MM(:,:,o,1));
            B=interp2(A,InterpN,'spline');
            [ymax xmax]=size(B);
            scalex=xmax/G;scaley=ymax/C;

    figure ('position',[30 30 400 360])

    %colormap jet
        for j=1:length(Tv)
            t=Tv(j);
            A=(MM(:,:,o,t));
            B=interp2(A,InterpN,'spline');
            surf(B,'EdgeColor','none');
            set(gcf,'Colormap',mycmap)
            axis([0 xmax 0 ymax 0 Cmax]);
            view(viewpoint);
            set(gca,'YTick',0:2*scaley:ymax,'YTickLabel',[0;2;4;6;8], ...
                'XTick',0:10*scalex:xmax,'xTickLabel',[0;10;20;30;40;50;60;70;80;90;100;110], ...
                'FontWeight','bold','CLimMode','manual','CLim',[0, Cmax],'LineWidth',2,'FontSize',12)
            xlabel('Glomeruli','FontWeight','bold','FontSize',16);
            ylabel('Conc','FontWeight','bold','FontSize',16);
            zlabel('\DeltaF/F','FontWeight','bold','FontSize',16);
            title({strcat(M.Project.Folder,'Odor-',int2str(o),cell2mat(M.Experiment.Odor.Name(M.Data.Sort.vOdor(OGN))));strcat('Frame',num2str(t))},'FontWeight','bold','FontSize',16)
            Mov(j) = getframe(gcf);
        end
end

%close