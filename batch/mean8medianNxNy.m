function [X, Y, meanOfYForEachXBin, meanOfXForEachYBin, medianOfYForEachXBin, medianOfXForEachYBin, xBinCenter,yBinCenter] = mean8medianNxNy(X,Y,nx,ny,path)

if nargin<4
    X = [0.1 0.2 0.3 0.2]';
    Y = [0.3 0.5 0.6 0.1]';
    nx=3;
    ny=2;
end

[jointPMF,jointCenter]=hist3([X' Y'],[nx ny]);
jointPMF = jointPMF';
xBinCenter = jointCenter{1};
yBinCenter = jointCenter{2};

xBinWidth = xBinCenter(2)-xBinCenter(1);
for i=1:length(xBinCenter)
    if i==1
        lb = 0;
    else
        lb = xBinCenter(i) - 0.5*xBinWidth + eps;
    end
    if i==length(xBinCenter)
        ub = inf;
    else
        ub = xBinCenter(i) + 0.5*xBinWidth - eps;
    end
    indForBinXI = (X > lb) & (X < ub);
    YForBinXI = Y(indForBinXI);
    meanOfYForEachXBin(i) = mean(YForBinXI);
    medianOfYForEachXBin(i) = median(YForBinXI);
    if isnan(meanOfYForEachXBin(i)) || isnan(medianOfYForEachXBin(i))
        disp('this should not happen');
    end
end

yBinWidth = yBinCenter(2)-yBinCenter(1);
for i=1:length(yBinCenter)
    if i==1
        lb = 0;
    else
        lb = yBinCenter(i) - 0.5*yBinWidth + eps;
    end
    if i==length(yBinCenter)
        ub = inf;
    else
        ub = yBinCenter(i) + 0.5*yBinWidth - eps;
    end
    indForBinYI = (Y > lb) & (Y < ub);
    XForBinYI = X(indForBinYI);
    meanOfXForEachYBin(i) = mean(XForBinYI);
    medianOfXForEachYBin(i) = median(XForBinYI);
    if isnan(meanOfXForEachYBin(i)) || isnan(medianOfXForEachYBin(i))
        disp('this should not happen');
    end    
end

if sum(isnan(meanOfYForEachXBin))>0 || sum(isnan(meanOfXForEachYBin))>0
    disp('this should not happen');
end
% 
% MeanMedian = fullfile(path,'MeanMedian.mat')
% save (MeanMedian,'X','Y','meanOfYForEachXBin','meanOfXForEachYBin', 'medianOfYForEachXBin', 'medianOfXForEachYBin', 'xBinCenter','yBinCenter');

