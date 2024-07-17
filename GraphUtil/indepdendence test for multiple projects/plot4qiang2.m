%% to produce the independence test across a number of projects
%  you may need modifications on this file to work with your own set of projects

projectsDir = 'L:\Lab Member data files\Elden\Qiang bulb imaging data';

cproj = 0;
pdirs = dir(projectsDir);
for i=1:length(pdirs)
    if pdirs(i).isdir==0 || strcmp(pdirs(i).name,'.') || strcmp(pdirs(i).name,'..')
        continue;
    end
    tDir = fullfile(projectsDir,pdirs(i).name);
            

    %% compute
    toLoad1 = fullfile(tDir,'Project.mat');
    if exist(toLoad1,'file')==0        
        continue;
    end    
    disp(tDir);
    M = load(toLoad1);
    plot4qiangComputeOdorD(M);
        
    
    %% compare
    toLoad2 = fullfile(tDir,'Compare2','compare2.mat');
    if exist(toLoad2,'file')==0        
        error('need compare2.mat');
    end    
    load(toLoad2,'OurPDist','TheirPDist');
    cproj = cproj + 1;
    ours{cproj} = OurPDist;
    theirs{cproj} = TheirPDist;
end
disp(sprintf('total %d projects collected!',cproj));

for i=1:4
    if i==1
        src1 = 'ours all concentration';
    else
        src1 = sprintf('ours concentration %d',i-1);
    end    
    for j=1:2
        if j==1
            src2 = 'theirs full descriptor';
        else
            src2 = 'theirs optimum descriptor';
        end        
        for k=1:5
           switch k
                case 1
                    option = 'original';
                case 2
                    option = 'zscore';
                case 3
                    option = 'normr';
                case 4
                    option = 'tiedrank';
                case 5
                    option = 'cosine';
            end            
            % concatenate across projects
            ourpd = [];
            theirpd = [];
            for z=1:cproj
                tmp1 = ours{z};
                tmp1 = tmp1{i,k};
                ourpd = [ourpd tmp1];
                tmp2 = theirs{z};
                tmp3 = tmp2{i,j,k};
                theirpd = [theirpd tmp3];
            end
            % plotTitle1 = [src1 ' ' option];
            title = [src1 '-' src2 '-' option '-IndependenceTest'];
            mDif = TestIndependence(theirpd,ourpd,20,20);
            PATHNAME = 'L:\Lab Member data files\Elden\Qiang bulb imaging data\';
            print('-cmyk','-djpeg','-f1',strcat(PATHNAME,title,'.jpg'));
            saveas(gcf,strcat(PATHNAME,title,'.fig'))
            close            
            %pause();
        end
    end
end

