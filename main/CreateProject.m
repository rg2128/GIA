function [M] = CreateProject(destDir,sourceDir)
%% Make Directories
mkdir(destDir);

%% Import Raw Data Parameters
[Project Experiment Process N]=ParameterRead(fullfile(sourceDir,'Parameters.xls'));

%% Import Raw Data
[Data]=RawDataRead(sourceDir,N);

%% Import ROI Data
Data.ROI=ROIRead(fullfile(sourceDir,'ROI.txt'),Project.ROI(1));

%% Create Process Custom Settings

Process.S=zeros(Data.G,14,Data.T);
Project.Folder=destDir;

save(fullfile(destDir,'Project.mat'),'Project','Experiment','Process','Data');
M.Project=Project;
M.Project.Folder=destDir;
M.Experiment=Experiment;
M.Process=Process;
M.Data=Data;

end