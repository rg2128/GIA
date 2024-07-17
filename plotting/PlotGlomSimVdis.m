%calculating similarity in receptive field among glomeruli, plot the
%similary against physical distances. 
%
%The function take the form
%[R SIM SIMr]=PlotGlomSimVdis(M,option,conc)
%
%Returns three vectors:
%R: pairwise distance vector
%SIM: Pairwise Similarity Vectore
%SIMr: Pairwise Similarity for shuffled matrix
%
%Input:
%M: the structure contains the dataset. Usually found as project.m in one
%of the GIA folders.
%
%options: 1, using euclidean distance; 2, using NormDotProduct; 3, using
%normalized ranks followed by euclidean clustering.
%
%conc: the concentration of the odors used in the calculation. If conc=0
%or if it is out of range, then all concentrations will be used for the
%calculation

function [R SIM SIMr]=PlotGlomSimVdis(M,option,conc)

if isequal(exist(fullfile(M.Project.Folder,'Analysis'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder),'Analysis')
end
% Check for Stats Folder
if isequal(exist(fullfile(M.Project.Folder,'Analysis/Stats'),'dir'),7)
else
    mkdir(fullfile(M.Project.Folder,'Analysis'),'Stats')
end

%set file path
PathName=fullfile(M.Project.Folder,'Analysis/Stats');

ROI=M.Data.ROI(M.Data.Sort.rGlom,:);
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
mPeak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
nConc=sum(M.Data.Sort.aConc(:));
if conc==0 || conc>nConc
    Peak=mPeak(:,:);      %make odor/conc into a single dimension
    concval='all conc';
else
    Peak=mPeak(:,conc,:);Peak=Peak(:,:);
    concval=strcat('conc',num2str(conc));
end

    [x y]=size(Peak);
    l=x*(x-1)/2;
    SIM=zeros(1,l);SIMr=zeros(1,l);
    R=zeros(1,l);

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
             SIM=1-pdist(Peak,'euclidean'); %calculating using Euclidean Distance
 
             PlotTitle='Euclidean Distance Similarity Plot';
         case 2
             k=1;
            for i=1:x-1
                if i>=x
                break
                else
                    for j=i+1:x
                        SIM(k)=sum(dot(Peak(i,:),Peak(j,:)))/sqrt(sum(dot(Peak(i,:),Peak(i,:)))*sum(dot(Peak(j,:),Peak(j,:))));
                        PlotTitle='NormDotProduct Similarity Plot';
                        k=k+1;
                    end                    
                end  
            end
         case 3
              %calculating using ranked response
              zPeak=normr(Peak);
              zRank=tiedrank(zPeak);
              SIM=0-pdist(zRank,'euclidean');
              PlotTitle='Ranked Response Similarity Plot';
    end
     
ll=length(SIM);
Rr=R(randperm(ll));

ProjectName = M.Project.Info{1,2};

figure ('position',[30 30 720 360])
subplot (1,2,1)
plot(R,SIM,'xk');axis ij;
title({PlotTitle;strcat(concval,'//',ProjectName)},'FontWeight','bold');
xlabel('Distance (\mum)','FontWeight','bold','FontSize',12);
ylabel('similarity','FontWeight','bold','FontSize',12);
set(gca,'FontWeight','bold','LineWidth',2)

subplot (1,2,2)
plot(Rr,SIM,'xk');axis ij;
title('Randomized Similiary vs. Distance','FontWeight','bold');
xlabel('Distance (\mum)','FontWeight','bold','FontSize',12);
ylabel('similarity','FontWeight','bold','FontSize',12);
set(gca,'FontWeight','bold','LineWidth',2)

    filename=strcat(ProjectName,'-option',num2str(option),'-GlomSimVDis');
    print('-cmyk','-djpeg','-f1',strcat(PathName,'/',filename,'.jpg'));
    saveas(gcf,strcat(PathName,'/',filename,'.fig'))
    close



     
