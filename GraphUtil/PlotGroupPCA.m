function PlotGroupPCA(PCAdata,option,Conc)

if nargin<3
    Conc=PCAdata.Odors.C;
end
if nargin<2
    Conc=PCAdata.Odors.C;
    option=1;
end


group=PCAdata.M.Experiment.Odor.Group(PCAdata.M.Data.Sort.vOdor);
grouplist=unique(group);
odors=PCAdata.M.Experiment.Odor.Name(PCAdata.M.Data.Sort.vOdor);
Abr=PCAdata.M.Experiment.Odor.Abr(PCAdata.M.Data.Sort.vOdor);

O=PCAdata.Odors.O;
C=PCAdata.Odors.C;

GroupN=length(grouplist);
ColorL(O,3)=0;
odorselect(1:O)=0;
S(1:O)=120;
for i=1:O
odorselect(i)=(i-1)*C+Conc;
end
scores(O,3)=0;
for i=1:3
switch option
    case 1
        scores(:,i)=PCAdata.PCAdata.Peakdata.scores(odorselect,i);
        method='Peak Intensity';
    case 2
        scores(:,i)=PCAdata.PCAdata.PeakNorm.scores(odorselect,i);
        method='Peak Normalized';
end
end

M(1)='o';M(2)='p';M(3)='h';M(4)='s';M(5)='^';M(6)='V';M(7)='*';M(8)='x';

figure
for i=1:GroupN
    odorTFlist=strcmp(grouplist(i),group);
    selectlist= find(odorTFlist==1);
    ColorL(selectlist,1)=i/GroupN;
    ColorL(selectlist,2)=abs((i-GroupN/2))/GroupN;
    ColorL(selectlist,3)=(GroupN-i)/GroupN;
    h=scatter3(scores(selectlist,1),scores(selectlist,2),scores(selectlist,3),S(selectlist),ColorL(selectlist),M(i),'filled');
    title ('PCA Distribution'); 
    set(gca,'LineWidth',3,'FontName','arial','FontSize',16,'FontWeight','bold')
    xlabel('PC1','FontName','arial','FontSize',20,'FontWeight','bold');
    ylabel('PC2','FontName','arial','FontSize',20,'FontWeight','bold');
    zlabel('PC3','FontName','arial','FontSize',20,'FontWeight','bold');
    
    hold on
end
legend(grouplist)
for i=1:O
    text(scores(i,1),scores(i,2),scores(i,3),Abr(i),'FontSize',12,'FontWeight','bold')
end