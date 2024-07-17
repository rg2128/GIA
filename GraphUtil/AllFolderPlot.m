%This function go through the folders and make all available plot

function AllFolderPlot

% Temporary: Add all function paths

addpath('../plotting')


PathName = uigetdir('C:/GIA');
D=dir(PathName);
L=length(D);

for k=3:L
Directory=strcat(PathName,'\',D(k).name);
    if isequal(Directory,0);
    else
        if isequal(exist(strcat(Directory,'\Project.mat'),'file'),2)
            M=load(strcat(Directory,'\Project.mat'));
            for i=1:3
            PlotGlomSimVdis(M,i,0);
            end
            PlotStats(M);
            %PlotAllSpatialandHeatmaps(M);
            
            display(strcat(Directory,':: All plot finished'))
                
        else
            display(strcat(Directory,'Project File does not Exist'))

            continue
        end
       
    end

end  