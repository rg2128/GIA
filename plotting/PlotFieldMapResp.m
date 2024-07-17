function PlotFieldMapResp(M,varargin)

%Plot field map of responses
%
%Format PlotFieldMapResp(M,varargin)
%
%Varargin specifies specific odor and concentration to plot. 
%If none is specified, the function plot out according to odor classes for
%all concentrations
%Varargin{1} speicifies odors. It takes the form of either a single digit
%or a vetor in the form [3 5 10].
%
%varargin{2} specifies concentration. It also takes multiple concentrations
%
%If varargin{1}=0, varargin{2} specifies the concentration. The function
%plots according to odor classes at the specified concentration.
%Examples:
%
%M=load('c:/GIA/GIA1/project.mat')
%PlotFieldMapResp(M)
%PlotFieldMapResp(M,0,8)
%PlotFieldMapResp(M,[12:16],8)
%PlotFieldMapResp(M,0,[3:8])
%PlotFieldMapResp(M,[3 5 8 9],[3 7 8])

% Check for Spacial Map Folder
% if isequal(exist(strcat('C:/GIA/',M.Project.Folder,'/Analysis/SpatialMaps'),'dir'),7)
%  rmdir(strcat('C:/GIA/',M.Project.Folder,'/Analysis/SpatialMaps'),'s')
%  mkdir(strcat('C:/GIA/',M.Project.Folder,'/Analysis'),'SpatialMaps')
% 
% else
    mkdir(fullfile(M.Project.Folder,'Analysis'),'SpatialMaps')
%end







if nargin>3
    error('too many arguments')
end
if nargin==0,   error('Input datamatrix missing'); end

O=sum(M.Data.Sort.aOdor);
C=sum(M.Data.Sort.aConc);
num_argin=numel(varargin);

Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
zRank=Peak(:,:);                         %make odor/conc into a single dimension

rOdorName=M.Experiment.Odor.Name(M.Data.Sort.vOdor);
rGroupName=M.Experiment.Odor.Group(M.Data.Sort.vOdor);

%assign odor groups to reordered matrix
    OdorGroup=cell(O*C,1);
    llist=zeros(O*C,1);
    for i=1:O
        for j=1:C
        OdorGroup(((i-1)*C+j),1)=rGroupName(i);
        end
    end
    List=unique(OdorGroup);
    List(length(List)+1)={'all'};
    LLength=length(List);
    %set subplot format by calculating row and column numbers
    rown=floor(sqrt(LLength));
    if rown^2==LLength
        coln=rown;
    else if rown*(rown+1)<LLength
            coln=rown+2;
        else
        coln=rown+1;
        end
    end

if num_argin==2
    OdorID=varargin{1};ConcID=varargin{2};
    
    if max(ConcID)>C
        display('Concentration Error! calculate according to highest concentrations');
        ConcID=C;
    end
    if min(OdorID)<=0 || max(OdorID)>O
            figure
            for i=1:LLength
                Group=List(i);
                for k=1:O
                    for j=1:length(ConcID)
                       llist((k-1)*C+ConcID(j))=isequal(OdorGroup((k-1)*C+ConcID(j)),Group);

                    end
                end

                if isequal(Group,{'all'})
                    llist(1:O*C)=0;
                    for k=1:O
                        for j=1:length(ConcID)
                        llist((k-1)*C+ConcID(j))=1;
                        end
                    end
                else

                end
                    olist=find(llist);
                sPeakRank=zRank(:,olist);
                Z=sum(sPeakRank,2);
                subplot(rown,coln,i)
                [X Y I]=ROIfield(M,Z,1,0.5);
                imagesc(X,Y,I);
                title(cell2mat(Group))
                xlabel(strcat('Conc',num2str(ConcID)))        
            end   
    else
        for i=1:length(OdorID)
            for j=1:length(ConcID)
                RespID((i-1)*length(ConcID)+j)=(OdorID(i)-1)*C+ConcID(j);
            end
        end
            sPeakRank=zRank(:,RespID);
            Z=sum(sPeakRank,2);
            figure
            [X Y I]=ROIfield(M,Z,1,0.5);
            imagesc(X,Y,I);
            OdorTitle='Odors:';
            for i=1:length(OdorID)
            OdorTitle=strcat(OdorTitle,cell2mat(rOdorName(OdorID(i))),'/');
            end
            title(OdorTitle)
            xlabel(strcat('Conc',num2str(ConcID)))
            end
end

if num_argin==1    
    OdorID=varargin{1};
        for i=1:length(OdorID)
            for j=1:C
                RespID((i-1)*C+j)=(OdorID(i)-1)*C+j;
            end
        end

    figure
    sPeakRank=zRank(:,RespID);
    Z=sum(sPeakRank,2);
    [X Y I]=ROIfield(M,Z,1,0.5);
    imagesc(X,Y,I);
    OdorTitle='Odors:';
    for i=1:length(OdorID)
    OdorTitle=strcat(OdorTitle,cell2mat(rOdorName(OdorID(i))),'/');
    end
    title(OdorTitle)
    xlabel('Conc=all')
end

if num_argin==0
        figure
    for i=1:LLength
        Group=List(i);
        for j=1:O*C
            llist(j)=isequal(OdorGroup(j),Group);
        end

        if isequal(Group,{'all'})
            olist=1:O*C;
        else
            olist=find(llist);
        end

        sPeakRank=zRank(:,olist);
        Z=sum(sPeakRank,2);
        subplot(rown,coln,i)
        [X Y I]=ROIfield(M,Z,1,0.5);
        imagesc(X,Y,I);
        title(cell2mat(Group))
        xlabel('Conc=all')
    end
end