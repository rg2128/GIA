function Z = ChooseColor(ROI,T)
%% to choose color for each cluster according to their spatial location
%  ROI: m by 2 matrix, each row represents a point (x,y)
%  T: m by 1 vector, with values from K clusters
%  Z: m by 3 matrix, with each row for one [R G B] value triple
%  Elden Yu @ 7/23/2010

if nargin<1
    ROI = [2 2;1 1;3 3;4 4];
    T = [1 2 3 2];
end

m = length(T);
ClassLabel = unique(T);
K = length(ClassLabel);
AllMean = zeros(K,2);
for k=1:K
    tClassLabel = ClassLabel(k);
    tClassInd = T==tClassLabel ;
    tROI = ROI(tClassInd,:);
    tMean = mean(tROI);
    AllMean(k,:) = tMean;
end
[dummy ind]= sortrows(AllMean,[2 1]);
ClassLabelSort = ClassLabel(ind);

%% choose K evenly distributed colors from customized color set
load('My31color.mat','My31Color');
nCol = length(My31Color);
chosenColor = [round(1:nCol/(K-1):nCol) nCol];
if length(chosenColor)~=K
    error('sth wrong with choosing colors');
end

%% 1-1 correspondence
Z = zeros(m,3);
for i=1:m
    tLabel = T(i);
    ind = find(ClassLabelSort==tLabel);
    Z(i,:) = My31Color(chosenColor(ind),:);
end


