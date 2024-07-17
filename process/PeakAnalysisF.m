function [PeakData PeakTimes] = PeakAnalysisF(y,P,Fs,Z)
%% Analyze Peak Data
PeakData=zeros(size(P,1),7);

L=length(y);
x=1:L;

if (isempty(P) || (isvector(P) && sum(P)==0))
    PeakTimes = [0 0];
    PeakData = [0 0 0 0 0 0 0]; 
    return;
end

for i=1:size(P,1) 
    px=P(i,2);
    py=P(i,3);
    p25y=0.25*py;
    p50y=0.50*py;
    p75y=0.75*py;

    j=find(Z(:,1)<=px,1,'last');
    a=Z(j,1);
    b=Z(j,2);

    if isempty(a)
       a=1;
       b=Z(1,1)-1;
    end

    r25x=find(y(a:px-1)<=p25y,1,'last')+a-1; 
    r50x=find(y(a:px-1)<=p50y,1,'last')+a-1;
    r75x=find(y(a:px-1)<=p75y,1,'last')+a-1;
    d25x=find(y(px+1:b)<=p25y,1,'first')+px;
    d50x=find(y(px+1:b)<=p50y,1,'first')+px;
    d75x=find(y(px+1:b)<=p75y,1,'first')+px;

    if isempty(r25x)
        r25x=px-1;
    end
    if isempty(r50x)
        r50x=px-1;
    end
    if isempty(r75x)
        r75x=px-1;
    end
    if isempty(d75x)
        d75x=px+1;
    end
    if isempty(d50x)
        d50x=px+1;
    end
    if isempty(d25x)
        d25x=px+1;
    end
    %figure
    %plot(x(a:b),y(a:b),'b',r25x,y(r25x),'xr',r50x,y(r50x),'xr',r75x,y(r75x),'xr',px,py,'xr',d75x,y(d75x),'xr',d50x,y(d50x),'xr',d25x,y(d25x),'xr')

    n=i*2;
    M(1,:)=[x(a)/Fs y(a)];
    M(2,:)=[r25x/Fs p25y];
    M(3,:)=[r50x/Fs p50y];
    M(4,:)=[r75x/Fs p75y];
    M(5,:)=[px/Fs py];
    M(6,:)=[d75x/Fs p75y];
    M(7,:)=[d50x/Fs p50y];  
    M(8,:)=[d25x/Fs p25y];
    M(9,:)=[x(b)/Fs y(b)];
    PeakTimes(:,n-1:n)=M;

    %Peak Integration
    if b>a+1
        A=1/Fs/2*(sum(y(a:b))+2*sum(y(a+1:b-1)));
    else
        A=0;
    end
    %Peak slopes
    rs=(p75y-p25y)/(r75x-r25x)*Fs;
    ds=(p25y-p75y)/(d25x-d75x)*Fs;
    PeakData(i,:)=[px px/Fs py (d50x-r50x)/Fs rs ds A];
end
PeakData(isinf(PeakData))=0;

end
