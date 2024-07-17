function TestIndependenceFor12Projects()
%% collect the same data with old computation 
%  from a given folder with multiple projects
%  test independence of Sim v.s. real physical distance 
%  Elden Yu @ 7/15/2010

dataDir = 'C:\GIA\TEMP'
allR = [];
allSIM = [];

pDirs = dir(dataDir);
for i=1:length(pDirs)
    %% check for valid projects
    if pDirs(i).isdir==0 || strcmp(pDirs(i).name,'.') || strcmp(pDirs(i).name,'..')
        continue;
    end
    tDir = fullfile(dataDir,pDirs(i).name);           
    toLoad1 = fullfile(tDir,'Project.mat');
    if exist(toLoad1,'file')==0
        continue;
    end    
    disp(tDir);
    M = load(toLoad1);
    
    %% copied from PlotGlomSimVdis.m
    %  we only care about R and SIM, so I didn't call but copy
    % 
    option = 2;
    conc = 0;
    
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
             
             SIM=1-pdist(Peak,'cosine'); %calculating using Euclidean Distance
 
             PlotTitle='NormDotProduct Similarity Plot';
%              k=1;
%             for i=1:x-1
%                 if i>=x
%                 break
%                 else
%                     for j=i+1:x
%                         SIM(k)=sum(dot(Peak(i,:),Peak(j,:)))/sqrt(sum(dot(Peak(i,:),Peak(i,:)))*sum(dot(Peak(j,:),Peak(j,:))));
% %                         if isnan(SIM(k))
% %                              disp('debug me');
% %                         end
%                         PlotTitle='NormDotProduct Similarity Plot';
%                         k=k+1;
%                     end                    
%                 end  
%             end
         case 3
              %calculating using ranked response
              zPeak=normr(Peak);
              zRank=tiedrank(zPeak);
              SIM=0-pdist(zRank,'euclidean');
              PlotTitle='Ranked Response Similarity Plot';
    end    
    
    badIndex = isnan(SIM);
    SIM = SIM(~badIndex);
    R = R(~badIndex);
    %%
    allR = [allR R];
    allSIM = [allSIM SIM];   
end

figure;scatter(allR,allSIM,'x');
[dummy, hFig] = TestIndependence(allR, allSIM, 40,40);
[meanOfYForEachXBin, meanOfXForEachYBin, medianOfYForEachXBin, medianOfXForEachYBin, xBinCenter,yBinCenter] = mean8medianNxNy(allR,allSIM,40,40,dataDir);
r = corr(allR', allSIM')
filename1 = fullfile(dataDir,'a.jpg');    
print(hFig,'-cmyk','-djpeg',filename1);     
filename2 = fullfile(dataDir,'a.fig');
saveas(hFig,filename2);
