function SimDisV=GlomSimVdisAll(option)
%Sum all Glomerular similarity over distance data for all the experiments
%under a single folder, plot the matrix of experimental data vs. randomized
%data set. 
%Option=distance calculating method
%options: 1, using euclidean distance; 2, using Correlation; 3, using
%normalized ranks followed by euclidean clustering.

PathName = uigetdir('C:/GIA');
D=dir(PathName);
L=length(D);

SIMALL=[];SIMrALL=[];RALL=[];SN=L-2;

for i=3:L
Directory=strcat(PathName,'\',D(i).name);
    if isequal(Directory,0);
    else
        if isequal(exist(strcat(Directory,'\Project.mat'),'file'),2)
            M=load(strcat(Directory,'\Project.mat'));
            [R SIM SIMr]=PlotGlomSimVdis(M,option);
            RALL=[RALL R];
            SIMALL=[SIMALL SIM];
            SIMrALL=[SIMrALL SIMr];
        else
            display(strcat(Directory,'Project File does not Exist'))
            SN=SN-1;
            continue
        end
    end
end

switch option
    case 1
    PlotTitle='Euclidean';
    case 2
    PlotTitle='Correlation';
    case 3
    PlotTitle='Ranked Response';
end
binx=round(max(RALL)/10);biny=binx;
SimX=[RALL' SIMALL']; 
[SimN,SimC]=hist3(SimX,[binx biny]);
SimXr=[RALL' SIMrALL'];
[SimNr,SimCr]=hist3(SimXr,[binx biny]);

SimDisV.SimN=SimN;
SimDisV.SimNr=SimN;
SimDisV.SimC=SimC;
SimDisV.SimCr=SimCr;
SimDisV.binx=binx;
SimDisV.biny=biny;
PairN=length(RALL);

figure('position',[40 40 720 360])

subplot (1,2,1)
imagesc(SimN');
set(gca,'YTick',0:binx/5:binx,'YTickLabel',[0;0.2;0.4;0.6;0.8;1.0], ...
    'XTick',0:40:biny, ...
    'xTickLabel',[0;400;800;1200;1600;2000], ...
    'FontWeight','bold')
xlabel('Distance (\mum)','FontWeight','bold','FontSize',12);
ylabel('similarity','FontWeight','bold','FontSize',12);
title({strcat('Ensemble Glom-Sim Plot --',PlotTitle);strcat('From',num2str(SN),'Bulbs-',num2str(PairN),'GlomPairs')});

subplot (1,2,2)
imagesc(SimNr');
set(gca,'YTick',0:binx/5:binx,'YTickLabel',[0;0.2;0.4;0.6;0.8;1.0], ...
    'XTick',0:40:biny, ...
    'xTickLabel',[0;400;800;1200;1600;2000], ...
    'FontWeight','bold')
xlabel('Distance (\mum)','FontWeight','bold','FontSize',12);
ylabel('similarity','FontWeight','bold','FontSize',12);
title('Randomized')



function [R SIM SIMr]=PlotGlomSimVdis(M,option)
ROI=M.Data.ROI(M.Data.Sort.rGlom,:);
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
Peak=Peak(:,:);
    [x y]=size(Peak);
    l=x*(x-1)/2;
    SIM=zeros(1,l);SIMr=zeros(1,l);
    R=zeros(1,l);
    RandomPeak=Peak(randperm(x),randperm(y));
    k=1;
    for i=1:x-1
        if i>=x
            break
        else
            for j=i+1:x
            R(k)=SF*sqrt((ROI(i,1)-ROI(j,1))^2+(ROI(i,2)-ROI(j,2))^2);
            k=k+1;
            end                    
        end
    end
    
    switch option
         case 1
             SIM=1-pdist(Peak); %calculating using Euclidean Distance
             SIMr=1-pdist(RandomPeak,'euclidean');

         case 2
             k=1;
            for i=1:x-1
                if i>=x
                break
                else
                    for j=i+1:x
                        SIM(k)=sum(dot(Peak(i,:),Peak(j,:)))/sqrt(sum(dot(Peak(i,:),Peak(i,:)))*sum(dot(Peak(j,:),Peak(j,:))));
                        SIMr(k)=sum(dot(RandomPeak(i,:),RandomPeak(j,:)))/sqrt(sum(dot(RandomPeak(i,:),RandomPeak(i,:)))*sum(dot(RandomPeak(j,:),RandomPeak(j,:))));

                        k=k+1;
                    end                    
                end  
            end
         case 3
              %calculating using ranked response
              zPeak=normr(Peak);
              zRank=tiedrank(zPeak);
              SIM=0-pdist(zRank,'euclidean');
              zrPeak=normr(RandomPeak);
              zrRank=tiedrank(zrPeak);
              SIMr=0-pdist(zrRank,'euclidean');

     end  