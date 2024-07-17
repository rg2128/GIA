%This function perform PCA analyses on the dataset and plot trajectories
%for the specified odors and concentrations. 
%The dataset (PCAdata) is calculated using a function called PeakPCA.m and
%is usually saved in the same directory as the main dataset project.m.
%
%Option value determines which processed data is used, as followed.
%1: use peak intensity data
%2: use peak Z scores
%3: use normalized peak intensity. The normalization generate values
%according to: xi=Xi/sqrt(sum(Xi^2).
%4: use normalized peak ranks. In this case, the normalized peak values are
%ranked for each odor application, using tiedrank function
%
%odor specifies the odors to be plotted. If odor=0, all odors will be
%plotted. It can take a number of odrs using the format [1 2 4 6]
%
%conc specifies the concentrations used in the plot. If conc=0, all
%concentrations will be used. It can take the bracket format as well.
%
%Example,
%PCAdata=load('c:/GIA/GIA1/PCAdata.mat')
%PlotPeakPCA(PCAdata,1,0,0)
%PlotPeakPCA(PCAdata,1,5,[3:8])
%PlotPeakPCA(PCAdata,4,[3:7 9 12],0)

function PlotPeakPCA(PCAdata,option,odor,conc)
% 
% % PCAdata = load('PCAdata.mat');
% option=1;
% conc =0;
% odor = 0;



O=PCAdata.Odors.O;
C=PCAdata.Odors.C;
rOdorAbr=PCAdata.Odors.Abr;
origlabel=PCAdata.Odors.label;

switch option
    case 1
        scores=PCAdata.PCAdata.Peakdata.scores;
        method='Peak Intensity';
    case 2
        scores=PCAdata.PCAdata.PeakZScore.scores;
        method='Peak Z Score';
    case 3
        scores=PCAdata.PCAdata.PeakNorm.scores;
        method='Peak Normalized';
    case 4
        scores=PCAdata.PCAdata.PeakRank.scores;
        method='Peak Rank';
end

odorlist=odor;    conclist=conc;
if odorlist(1,1)==0 && conclist(1,1)==0
    figure
    for i=1:O*C
        plot3(scores(i,1),scores(i,2),scores(i,3),'h','MarkerFacecolor','b','Markersize',10);
        hold on
        text(scores(i,1),scores(i,2),scores(i,3),strcat('\leftarrow',cell2mat(origlabel(i))));
    end
    xlabel('1st Component');ylabel('2nd Component');zlabel('3rd Component');
    title ('PCA Analysis of Odor Activation-All');
end

if odorlist(1,1)==0
    odorlist=1:O;
else
end

if conclist(1,1)==0
    conclist=1:C;
else
end

colorn=max(max(odorlist));[b,concN]=size(conclist);
figure

for i=odorlist
    x(1:concN)=0;y(1:concN)=0;z(1:concN)=0;s(1:concN)=0;c(1:concN,1:3)=0;
        for k=1:concN
        x(k)=scores((i-1)*C+conclist(k),1);
        y(k)=scores((i-1)*C+conclist(k),2);
        z(k)=scores((i-1)*C+conclist(k),3);
        s(k)=8*k; c(k,1)=(i-1)/colorn;c(k,2)=1-(i-1)/colorn;c(k,3)=1;
        end
        h=scatter3(x,y,z,s,c,'filled');
        hold on
        h=plot3(x,y,z,'-','Linewidth',3);
        set(h,'Color',[(i-1)/colorn,1-(i-1)/colorn,1]);
        %axis([xmin xmax ymin ymax zmin zmax]);
        text(x(k),y(k),z(k),rOdorAbr(i),'FontSize',12,'FontWeight','bold')
end
    title ({'PCA Trajectory of Odor Activation over Concentration'; method}); 
    set(gca,'LineWidth',3,'FontSize',12,'FontWeight','bold')
    xlabel('PC1','FontSize',16,'FontWeight','bold');
    ylabel('PC2','FontSize',16,'FontWeight','bold');
    zlabel('PC3','FontSize',16,'FontWeight','bold');
    