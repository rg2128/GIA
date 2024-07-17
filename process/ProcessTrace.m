function [ySmooth, yBase, ySignal, ...
    yFit, RisItvl, DecItvl, newFits, BaseFit] ...
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

% determine rising and decaying intervals, needed later
delayFrame = round(2*fps);
delayFrame2 = round(1*fps);
RisItvl = [OdorOnOff(:,1)+delayFrame2 OdorOnOff(:,2)+delayFrame];
DecItvl = [OdorOnOff(:,1) Zone(:,2)];
% DecItvl = [OdorOnOff(:,2) Zone(:,2)];
T = OdorOnOff(1,2)-OdorOnOff(1,1)+1;

% 1. smoothing
SmoothMethodList = {'moving','lowess','loess','sgolay','rlowess','rloess'};
ySmooth = smooth(yRaw,actPar(1),SmoothMethodList{actPar(2)});

% 2. baseline
BaseFit = [actPar(19) actPar(20)];
if actPar(18)==1
    if actPar(5)==0 % old baseline
        [dummy yBase] = msbackadj(transpose(1:length(ySmooth)),ySmooth,'WindowSize',actPar(3),'StepSize',actPar(4));
        y=ySmooth./yBase;
%         ymean=mean(y);
%         ystd=std(y);
%         ybase=y(find(y<ymean+ystd & y>ymean-2*ystd));
%         ybmed=median(ybase);
%         ySignal=y-ybmed;
        ySignal=y-1;
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
        
        % use median of the previous BufferSize points
        % instead of the original point at zeroInd(i)
        for i=1:length(zeroInd)
            BufferSize = 10; % tune this if necessary
            ValidBuffer = [];
            for ii=zeroInd(i)-BufferSize+1:zeroInd(i)
                if ii>0
                    ValidBuffer = [ValidBuffer ii];
                end
            end
            medianVB = median(y2(ValidBuffer));
            [dummy medianLOC] = min(abs(y2(ValidBuffer)-medianVB));            
            medianLOC = medianLOC(end);
            zeroInd(i) = ValidBuffer(medianLOC);
        end
        
        
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
        y2line(xEnd:end) = y2(xEnd:end);
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
else % modle as expo. with common time factor but different constants
    disp('modeling the baseline ...');
    if actPar(19)==-1 % auto fit
        tmpX = 1:OdorOnOff(1,1);
        tmpX = tmpX';
        tmpY = ySmooth(1:OdorOnOff(1,1));
        fit1 = fit(tmpX,tmpY,'exp1');
        BaseFit = [fit1.a fit1.b];        
    else
        BaseFit = [actPar(19) actPar(20)];
    end
    yBase = ySmooth;
    for i=1:length(yBase)
        yBase(i) = BaseFit(1)*exp(BaseFit(2)*i);
    end
    ySignal = ySmooth - yBase;
end


% 3. whether to fit the multi-piece model
yFit = ySignal;
newFits = oldFits;
% fitting on each zone if there is method specified   
for i=1:nZone
    xPiece = RisItvl(i,1):DecItvl(i,2);
    [yFitPiece,NewFit] = ProcessZone(ySignal(xPiece),actPar(6),oldFits(1,1,i),T);
    yFit(xPiece) = yFitPiece;
    newFits(1,1,i) = NewFit;
end

return;
