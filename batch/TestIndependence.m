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

%% difference5
difPMF = jointPMF - xyPMF;
subplot(2,2,4);
imagesc(jointCenter{1,1},jointCenter{1,2},difPMF,[min(difPMF(:)) max(difPMF(:))]);
%imagesc(jointCenter{1,1},jointCenter{1,2},difPMF,[0 max(jointPMF(:))]);
colorbar;

%% summary
mDif = mean(difPMF(1,:));

% for SimVDis
    % count how much bins seperated from smaller than a um
    a = sum(jointCenter{1,1}<500);

    % count how much bins seperated from >b  similarity.
    b = sum(jointCenter{1,2}>0.90);

    % caculate the percentage excess of all pairs seperated by a um.
    aa = sum(sum(difPMF((ny-b+1):ny,1:a)))/sum(sum(jointPMF(:,1:a)));
      
    difPMF2 = difPMF.*(difPMF>=0);
    
    aa2 = sum(sum(difPMF2((ny-b+1):ny,1:a)))/sum(sum(jointPMF(:,1:a)));

    % caculate the percentage excess of all pairs.
    bb = sum(sum(difPMF((ny-b+1):ny,1:a)))/sum(sum(jointPMF));
    
    bb2 = sum(sum(difPMF2((ny-b+1):ny,1:a)))/sum(sum(jointPMF));


% %      for SimVdescriptors
% %     count how much bins seperated from smaller than 0.6
%     a = sum(jointCenter{1,1}<0.6);
% 
% %     count how much bins seperated from >0.7 similarity.
%     b = sum(jointCenter{1,2}<(1-0.6));
% 
% %     caculate the percentage excess of all pairs seperated by 0.6
%     aa = sum(sum(difPMF(1:b,1:a)))/sum(sum(jointPMF(:,1:a)))
% 
% %     caculate the percentage excess of all pairs.
%     bb = sum(sum(difPMF(1:b,1:a)))/sum(sum(jointPMF))


