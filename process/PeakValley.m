function [P, PeakData, PeakTimes, ...
          V, ValleyData, ValleyTimes] ...
          = PeakValley(yFit, actPar, Zone, fps, RisItvl, DecItvl)
%% 
% Elden Yu @ Jun 7 2010
if isvector(actPar) % make row vector
    if size(actPar,1)>1
        actPar = actPar';
    end
else
    error('debug: actPar must be vector');
end
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

return;