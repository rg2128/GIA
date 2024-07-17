function [y yR yS yB P PeakData PeakTimes] = ProcessF(yR,Fs,aS,Z)
%% Peak Sign
if aS(1)
else
    yR=-yR;
end

%% Smooth Data
[yS]=SmoothF(yR,aS);

%% Baseline Correction
[y yB]=BaselineF(yS,aS);
%% Peak Sign
if aS(1)
else
    y=-y;
end
%% Find Peaks
[P] = PeakFinderF(y,aS);

%% Analyze Peaks
[PeakData PeakTimes]=PeakAnalysisF(y,P,Fs,Z);
%% Peak Sign
if aS(1)
else
    yR=-yR;
    yS=-yS;
    yB=-yB;
    y=-y;
    P(:,3)=-P(:,3);
    PeakData=PeakData*diag([1; 1; -1; 1; -1; -1; 1]);
    PeakTimes(:,2:2:length(PeakTimes(1,:)))=-PeakTimes(:,2:2:length(PeakTimes(1,:)));
end

end