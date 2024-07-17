function [mDif hFig] = TestIndependence(X,Y,nx,ny)
%% test whether two vectors are independent
%  X,Y: vectors
%  nx, ny: # of bins used in formulating a discrete distribution
%  [X(i),Y(i)] treated as a point in joint distribution
%  Elden Yu @ July 1 2010

if ~isvector(X) || ~isvector(Y)
    error('both X and Y must be vectors');
end
if size(X,2)>1
    X = X';
end
if size(Y,2)>1
    Y = Y';
end

%% joint PMF
[jointPMF,jointCenter]=hist3([X Y],[nx ny]);
jointPMF = jointPMF' / length(X);

hFig = figure;
subplot(2,2,1);
imagesc(jointCenter{1,1},jointCenter{1,2},jointPMF,[0 max(jointPMF(:))]);
colorbar;

%% marginal PMF
xPMF = hist(X,jointCenter{1,1});
xPMF = xPMF/length(X);
yPMF = hist(Y,jointCenter{1,2});
yPMF = yPMF/length(X);

subplot(2,2,2);
plot(xPMF,'b');
hold on;
plot(yPMF,'g');

%% product of marginal PMF's
xyPMF = yPMF'*xPMF;
% xyPMF = flipud(fliplr(xyPMF));
subplot(2,2,3);
imagesc(jointCenter{1,1},jointCenter{1,2},xyPMF,[0 max(jointPMF(:))]);
colorbar;

%% difference
difPMF = jointPMF - xyPMF;
subplot(2,2,4);
imagesc(jointCenter{1,1},jointCenter{1,2},difPMF,[min(difPMF(:)) max(difPMF(:))]);
%imagesc(jointCenter{1,1},jointCenter{1,2},difPMF,[0 max(jointPMF(:))]);
colorbar;

%% summary
mDif = mean(difPMF(:));
