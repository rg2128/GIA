function [yS] = SmoothF(yR,aS)
%% Settings
SmoothActive=aS(2);
Span=aS(3);
MethodNum=aS(4);

%% Smooth Raw Data
if SmoothActive == 1
    switch MethodNum
        case 1
            Method='moving';
        case 2
            Method='lowess';
        case 3
            Method='loess';
        case 4
            Method='sgolay';
        case 5
            Method='rlowess';
        case 6
            Method='rloess';
        otherwise
            Method='moving';
    end
    yS=smooth(yR,Span,Method);
else
    yS=yR; 
end

end