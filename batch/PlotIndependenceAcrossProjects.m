%% to produce independence test results over data from multiple projects
%  assuming compare2.mat has been produced in each project
%  by pressing the plot odor descriptor button in GIAplots
%
%  Elden Yu @ 7/12/2010

projectsDir = 'L:\Lab Member data files\Elden\Qiang bulb imaging data';

cproj = 0;
pdirs = dir(projectsDir);
for i=1:length(pdirs)
    if pdirs(i).isdir==0 || strcmp(pdirs(i).name,'.') || strcmp(pdirs(i).name,'..')
        continue;
    end
    tDir = fullfile(projectsDir,pdirs(i).name);       
    
    %% compute compare2.mat, comment out if data already computed
    toLoad1 = fullfile(tDir,'Project.mat');
    if exist(toLoad1,'file')==0
        continue;
    end
    disp(tDir);
    M = load(toLoad1);
    M.Project.Folder = tDir;
    ComputeOdorPD(M);    
    
    %% compare
    toLoad2 = fullfile(tDir,'compare2.mat');
    if exist(toLoad2,'file')==0        
        error([toLoad2 blanks(1) 'not there!']);
    end
    load(toLoad2,'OurPDist','TheirPDist');
    cproj = cproj + 1;
    ours{cproj} = OurPDist;
    theirs{cproj} = TheirPDist;
end
disp(sprintf('total %d projects collected!',cproj));

preOption = {'raw','normr','zscore','tiedrank','normr2zscore','zscore2normr'};
pcaOption = {'WithoutPCA','WithPCA'};
disOption = {'euclidean','cosine'};
for i=1:4
    if i==1
        src1 = 'response all concentration';
    else
        src1 = sprintf('response concentration %d',i-1);
    end    
    for j=1:3
        if j==1
            src2 = 'descriptor full';
        else
            if j==2
                src2 = 'descriptor optimum 40';
            else
                src2 = 'descriptor optimum 20';
            end
        end        
        for k=1:24
            [I1 I2 I3]=ind2sub([length(preOption) length(pcaOption) length(disOption)],k);
            OurOpt = [preOption(I1) pcaOption(I2) disOption(I3)];
            
            for kk=1:24
                disp(sprintf('i=%d,j=%d,k=%d,kk=%d',i,j,k,kk));
                [I1 I2 I3]=ind2sub([length(preOption) length(pcaOption) length(disOption)],kk);
                TheirOpt = [preOption(I1) pcaOption(I2) disOption(I3)];

                % concatenate across projects
                ourpd = [];
                theirpd = [];
                for z=1:cproj
                    tmp1 = ours{z};
                    tmp1 = tmp1{i,k};
                    ourpd = [ourpd tmp1];
                    tmp2 = theirs{z};
                    tmp3 = tmp2{i,j,kk};
                    theirpd = [theirpd tmp3];
                end
                % plotTitle1 = [src1 ' ' option];
                title = [src1 '-' OurOpt '-' src2 '-' TheirOpt '-IndependenceTest'];
                mDif = TestIndependence(theirpd,ourpd,20,20);
                print('-cmyk','-djpeg','-f1',strcat(projectsDir,title,'.jpg'));
                saveas(gcf,strcat(projectsDir,title,'.fig'))
                close
                %pause();
            end
        end
    end
end

