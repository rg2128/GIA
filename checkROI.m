%This function check the stored ROI in the project.m file against the
%original ROI.txt. If there is non-match, a warning list is generated.
%option default is no correction.
%option=1 the ROI file in the project.m file is corrected.
function checkROI(option)

if nargin<1
    option=0;
end
if isequal(option,1)==false
    option=0;
end

PathName = uigetdir('C:/GIA');
D=dir(PathName);
L=length(D);

for k=3:L
Directory=strcat(PathName,'\',D(k).name);
    if isequal(Directory,0);
    else
        if isequal(exist(strcat(Directory,'\Project.mat'),'file'),2)
            load(strcat(Directory,'\Project.mat'));
            filename=strcat(Directory,'\ROI.txt');

            ROIm=textread(filename,'%q');
            Li=length(ROIm);
            x(1:Li)=0;
            y(1:Li)=0;

                for i=1:Li
                    X='';
                    Y='';
                    M=cell2mat(ROIm(i,:));
                    Lj=length(M);
                    Xswitch=false;
                    Yswitch=false;
                    for j=1:Lj
                        if M(j) == '-'
                            Xswitch=false;
                        end
                        if Xswitch == true
                            X=strcat(X,M(j));
                        end
                        if Yswitch == true
                            Y=strcat(Y,M(j));
                        end
                        if M(j) == 'O'
                            Xswitch=true;
                        end
                        if M(j) == '-'
                            Yswitch=true;           
                        end
                        x(i)=str2double(X);
                        y(i)=str2double(Y);
                    end
                end
                ROI=transpose([x;y]);
                
                checkedout=isequal(ROI, Data.ROI);
                switch checkedout
                    case 1
                          display (strcat(Directory,':ROI OK'))
                    case 0        
                          display (strcat(Directory,':ROI ALTERED'))
                           if option==1
                               Data.ROI=ROI;
                            save(strcat(Directory,'\Project.mat'),'Project','Experiment','Process','Data');
                            display('ROI corrected. Project Saved')
                           end
                end
                
        else
            display(strcat(Directory,'Project File does not Exist'))

            continue
        end
       
    end
 clear x y
end  