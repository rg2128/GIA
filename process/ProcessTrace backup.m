function [ySmooth, yBase, ySignal, ...
    yFit, RisItvl, DecItvl, newFits,...
    P, PeakData, PeakTimes, ...
    V, ValleyData, ValleyTimes ] ...
    = ProcessTrace(yRaw,actPar,Zone,OdorOnOff,fps,oldFits)
%% To process just one trace
%
%  5 Inputs:
%  yRaw:  Data.Raw(:,g,ot)
%  actPar:  handles.actPar in GIAreview.m, 17 parameters for the current trace
%  Zone:    Experiment.Zone.Duration
%  OdorOnOff:  same size as Zone, each row denotes the odor on and off frame
%  fps: frame per second, for the half-second delay in rising interval
%  oldFits: fitting parameter set for all zones in this t/g
%  whichZone: 0 means all zones
%
%  13 Outputs:
%
%  Elden Yu @ May 21 2010
%  Added more fitting @ June 3

nZone = size(Zone,1);
if isvector(actPar)
    if size(actPar,1)>1
        actPar = actPar';
    end
end

% 1. smoothing
SmoothMethodList = {'moving','lowess','loess','sgolay','rlowess','rloess'};
ySmooth = smooth(yRaw,actPar(1),SmoothMethodList{actPar(2)});

% 2. baseline
if actPar(5)==0 % old baseline
    [dummy yBase] = msbackadj(transpose(1:length(ySmooth)),ySmooth,'WindowSize',actPar(3),'StepSize',actPar(4));
    y=ySmooth./yBase;
    ymean=mean(y);
    ystd=std(y);
    ybase=y(find(y<ymean+ystd & y>ymean-2*ystd));
    ybmed=median(ybase);
    ySignal=y-ybmed;
else % new baseline
    %  y1 is the difference between ySmooth and yB1 
    [y1 yB1] = msbackadj(transpose(1:length(ySmooth)),ySmooth,'WindowSize',actPar(3),'StepSize',actPar(4));
    %  y2 is normalized y1
    y2 = y1./yB1;
    %  find the points where signal=0
    tmp = [Zone OdorOnOff]; % 4 columns [ZoneStart ZoneEnd OdorOn OdorOff]
    tmp = tmp(:,[1 3]); % keep only ZoneStart and OdorOn
    tmp = tmp'; 
    tmp = tmp(:); % to line by columns 
    tmp = tmp'; % back to row vector
    zeroInd = [1 tmp Zone(nZone,2) length(yRaw)];
    zeroInd = unique(zeroInd);   
    %  y2line is a multi-piece line connecting y2 at zeroInd  
    y2line = inf(size(y2));
    for i=1:length(zeroInd)-1
        % make a line
        xBegin = zeroInd(i);
        yBegin = y2(xBegin);
        xEnd = zeroInd(i+1);
        yEnd = y2(xEnd);
        kLine = (yEnd-yBegin)/(xEnd-xBegin);
        for j=xBegin:xEnd
            y2line(j) = (j-xBegin)*kLine + yBegin;
        end     
    end
    if sum(isinf(y2line))~=0
        error('debug: y2line should has no inf');
    end
    % y is y2 corrected, so that it is zero at starting and ending of each zone
    ySignal = y2 - y2line;
    if sum(ySignal==-1)~=0
        error('debug: ySignal cannot be -1');
    end
    yBase = ySmooth./(1+ySignal); 
end

% determine rising and decaying intervals, needed later
delayFrame = round(2*fps);
RisItvl = [OdorOnOff(:,1) OdorOnOff(:,2)+delayFrame];
DecItvl = [OdorOnOff(:,2) Zone(:,2)];

% 3. whether to fit the multi-piece model
yFit = ySignal;
newFits = oldFits;
% fitting on each zone if there is method specified   
if actPar(6)>1
    for i=1:nZone
        switch actPar(6)
            case 2, % two-piece double exponential
                % fitting the decay piece
                xPiece = DecItvl(i,1):DecItvl(i,2);
                yPiece = ySignal(xPiece);
                S = exp2fit(xPiece,yPiece,2,'no');
                yPiecePredict = real(doubleExpDecay(xPiece,S));
                yFit(xPiece) = yPiecePredict;                
                % fitting the rising piece
                xPiece = RisItvl(i,1):RisItvl(i,2);
                yPiece = ySignal(xPiece);
                S = exp2fit(xPiece,yPiece,2,'no');
                yPiecePredict = real(doubleExpDecay(xPiece,S));
                yFit(xPiece) = yPiecePredict;                
            case 3,% 4-piece exponential
                xPiece = RisItvl(i,1):DecItvl(i,2);
                if oldFits(1,1,i).autofit
                    yPiece = ySignal(xPiece);                
                    opt = fitoptions(...
                        'METHOD','nonlinearLeastSquares',...
                        'Lower',oldFits(1,1,i).lb,...
                        'Upper',oldFits(1,1,i).ub,...
                        'startPoint', (oldFits(1,1,i).lb+oldFits(1,1,i).ub)/2);
                    modelFun = 'Excit2Inhibit(X,T,a,b,c,d,e,f,tau)';
                    ft = fittype(modelFun,'independent','X','dependent','Y','options',opt);
                    tmpX = 1:length(yPiece);
                    tmpX = tmpX';
                    ff = fit(tmpX,yPiece,ft);
                    newFits(1,1,i).auto = [ff.T,ff.a,ff.b,ff.c,ff.d,ff.e,ff.f,ff.tau];
                    [yPiecePredict dummy1 dummy2] = Excit2Inhibit(tmpX,ff.T,ff.a,ff.b,ff.c,ff.d,ff.e,ff.f,ff.tau);                
                else
                    manu = oldFits(1,1,i).manual;
                    [yPiecePredict dummy1 dummy2] = Excit2Inhibit(xPiece,...
                        manu(1),manu(2),manu(3),manu(4),...
                        manu(5),manu(6),manu(7),manu(8));                
                end
                yFit(xPiece) = yPiecePredict;
            case 4,% 4-piece 2 logistic sigmoid 2 exponential
                xPiece = RisItvl(i,1):DecItvl(i,2);
                if oldFits(1,1,i).autofit
                    yPiece = ySignal(xPiece);                
                    opt = fitoptions(...
                        'METHOD','nonlinearLeastSquares',...
                        'Lower',oldFits(1,1,i).lb,...
                        'Upper',oldFits(1,1,i).ub,...
                        'startPoint', (oldFits(1,1,i).lb+oldFits(1,1,i).ub)/2);
                    modelFun = 'Excit2InhibitLS(X,T,a,b,c,d,e,f,tau)';
                    ft = fittype(modelFun,'independent','X','dependent','Y','options',opt);
                    tmpX = 1:length(yPiece);
                    tmpX = tmpX';
                    ff = fit(tmpX,yPiece,ft);                    
                    newFits(1,1,i).auto = [ff.T,ff.a,ff.b,ff.c,ff.d,ff.e,ff.f,ff.tau];
                    [yPiecePredict dummy1 dummy2] = Excit2InhibitLS(tmpX,ff.T,ff.a,ff.b,ff.c,ff.d,ff.e,ff.f,ff.tau);                
                else
                    manu = oldFits(1,1,i).manual;
                    [yPiecePredict dummy1 dummy2] = Excit2InhibitLS(xPiece,...
                        manu(1),manu(2),manu(3),manu(4),...
                        manu(5),manu(6),manu(7),manu(8));                
                end
                yFit(xPiece) = yPiecePredict;                
        end        
    end  % each zone  
end % method

% 4a. use old method for finding praks
P = PeakFinderF(yFit,[1 1 actPar(1:4) actPar(7:10)]);
% % get rid off extra peaks
pInd = [];
if ~isempty(P)
    for i=1:size(Zone,1)
        tmpInd = find(P(:,2)>=RisItvl(i,1) & P(:,2)<=RisItvl(i,2));        
        if length(tmpInd) > 0
            if length(tmpInd)>1
                [dummy,tmp] = max(P(tmpInd,3));
                tmpInd = tmpInd(tmp);
            end
            pInd = [pInd tmpInd];            
        end
    end
end
P = P(pInd,:);
[PeakData PeakTimes]=PeakAnalysisF(yFit,P,fps,Zone);

% 4b. 
V = PeakFinderF(-yFit,[1 1 actPar(1:4) actPar(11:14)]);
% % get rid off extra peaks
vInd = [];
if ~isempty(V)
    for i=1:size(Zone,1)
        tmpInd = find(V(:,2)>=DecItvl(i,1) & V(:,2)<=DecItvl(i,2));
        if length(tmpInd) > 0
            if length(tmpInd)>1
                tmpInd = tmpInd(1); % the valley immediately after OdorOn
            end
            vInd = [vInd tmpInd];            
        end
    end
end
V = V(vInd,:);
[ValleyData ValleyTimes]=PeakAnalysisF(-yFit,V,fps,Zone);

end



