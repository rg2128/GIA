function [y yB] = BaselineF(yS,aS)
%% Settings
WindowSizeValue=aS(5);
StepSizeValue=aS(6);
    
%% Baseline Correction
x=transpose(1:length(yS));
[y yB] = msbackadj(x,yS,'WindowSize',WindowSizeValue,'StepSize',StepSizeValue);
y=yS./yB;

% Zero Offset I
ymean=mean(y);
ystd=std(y);
ybase=y(find(y<ymean+ystd & y>ymean-2*ystd));
ybmed=median(ybase);
y=y-ybmed;

end