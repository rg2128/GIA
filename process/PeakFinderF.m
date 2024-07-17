function [P] = PeakFinderF(y,aS)
%% Settings
SlopeThreshold=aS(7);
AmpThreshold=aS(8);
SmoothWidth=aS(9);
FitWidth=aS(10);

%% Elden modification starts @ may 24 2010
% 0 causes trouble here
if SmoothWidth==0
    SmoothWidth = 1;
end
%  Elden modification ends

%% Find Peaks

P=findpeaks(1:length(y),y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth);

end