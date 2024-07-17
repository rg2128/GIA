%Plot field map of the rank of response for individual glomerulus
%
%PlotFieldMapRespRankNormalized(M,Option,varargin)
%
%M: the input data structure
%
%Option: 0=default, with normalization; 1=no normalization;
%Varargin specifies specific odor and concentration to plot. 
%If none is specified, the function plot out according to odor classes for
%all concentrations
%Varargin{1} speicifies odors. It takes the form of either a single digit
%or a vetor in the form [3 5 10].
%varargin{2} specifies concentration.
%If varargin{1}=0, varargin{2} specifies the concentration. The function
%plots according to odor classes at the specified concentration.
%Examples:
%
%M=load('c:/GIA/GIA1/project.mat')
%PlotFieldMapResp(M)
%PlotFieldMapResp(M,0,0,8)
%PlotFieldMapResp(M,1,[12:16],8)
%PlotFieldMapResp(M,0,0,[3:8])
%PlotFieldMapResp(M,0,[3 5 8 9],[3 7 8])

function PlotFieldMapRespRankNormalized(M,Option,varargin)
if nargin>4
    error('too many arguments')
end
if nargin==0,   error('Input datamatrix missing'); end
if nargin<2
    Option=0;
end


if isequal(exist(fullfile(M.Project.Folder,'Analysis/SpatialMaps'),'dir'),7)
 
else
    mkdir(fullfile(M.Project.Folder,'Analysis'),'SpatialMaps')
end



O=sum(M.Data.Sort.aOdor);
C=sum(M.Data.Sort.aConc);
num_argin=numel(varargin);

Peak=permute(M.Data.Sort.Peak,[2 1 3]); %obtain data
Peak=Peak(:,:);                    %make odor/conc into a single dimension
switch Option
    case 0
        zPeak=normr(Peak); %normalize the rows for the responses for each glomerulus
    case 1
        zPeak=Peak;
end
zRank=tiedrank(zPeak);            %get ranks of glomeruli for each odor stilumation

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
            Z=zscore(sum(sPeakRank,2));
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
        Z=zscore(sum(sPeakRank,2));% sum all responses before z-score
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
    Z=zscore(sum(sPeakRank,2));
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
        Z=zscore(sum(sPeakRank,2));
        subplot(rown,coln,i)
        [X Y I]=ROIfield(M,Z,1);
        imagesc(X,Y,I);
        xlabel('Conc=all')
        title(cell2mat(Group))
    end
end