function [RALL SIMALL]=GlomSimVdisAll(option)
%Sum all Glomerular similarity over distance data for all the experiments
%under a single folder, return the values of distance and similarity for further analyis.
%Option=distance calculating method
%options: 1, using euclidean distance; 2, using Correlation; 3, using
%normalized ranks followed by euclidean clustering.
%
%Output RALL is a vector of Distance between pairs of glomeruli
%       SIMALL is a vector of similarity between pairs of glomeruli.

PathName = uigetdir('C:/GIA');
D=dir(PathName);
L=length(D);

SIMALL=[];RALL=[];

for i=3:L
Directory=strcat(PathName,'\',D(i).name);
    if isequal(Directory,0);
    else
        if isequal(exist(strcat(Directory,'\Project.mat'),'file'),2)
            M=load(strcat(Directory,'\Project.mat'),'Data');
            Project=load(strcat(Directory,'\Project.mat'),'Project');
            ROI=M.Data.ROI(M.Data.Sort.rGlom,:);
            SF=cell2mat(Project.Project.ROI(5));              % Scaling Factor(um/pixel)
            Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
            Peak=Peak(:,:);
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
            RALL=[RALL R];    
            SIM=GlomSim(Peak,option);
            SIMALL=[SIMALL SIM];
        else
            display(strcat(Directory,'Project File does not Exist'))
            SN=SN-1;
            continue
        end
    end
end
save(strcat(Directory,'GlomSimDisValue.mat'),'RALL','SIMALL')


function SIM=GlomSim(Peak,option)

    switch option
         case 1
             SIM=1-pdist(Peak); %calculating using Euclidean Distance
         case 2
             k=1;[x y]=size(Peak);
            for i=1:x-1
                if i>=x
                break
                else
                    for j=i+1:x
                        SIM(k)=sum(dot(Peak(i,:),Peak(j,:)))/sqrt(sum(dot(Peak(i,:),Peak(i,:)))*sum(dot(Peak(j,:),Peak(j,:))));
                        k=k+1;
                    end                    
                end  
            end
         case 3
              %calculating using ranked response
              zPeak=normr(Peak);
              zRank=tiedrank(zPeak);
              SIM=0-pdist(zRank,'euclidean');
     end  