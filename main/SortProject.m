function [M] = SortProject(M)

Z=M.Experiment.Zone.Duration;
% Zn=Z(1,2)-Z(1,1)+1;
% modified by Elden @ 9/29/2011 to accomodate unequal zone width
% 

ZoneWidth = Z(:,2)-Z(:,1)+1;
Zn = max(ZoneWidth);
n=1;
c2n=zeros(M.Data.C,1);
for i=1:M.Data.C
   if M.Data.Sort.aConc(i)
        c2n(i)=n;
        n=n+1;
   end
end

Sorted=zeros(Zn*max(c2n),M.Data.G,M.Data.O)-1; % add -1 to remind bad data
Peak=zeros(M.Data.C,M.Data.G,M.Data.O);
PeakWidth=zeros(M.Data.C,M.Data.G,M.Data.O);
Rise=zeros(M.Data.C,M.Data.G,M.Data.O);
Fall=zeros(M.Data.C,M.Data.G,M.Data.O);
Area=zeros(M.Data.C,M.Data.G,M.Data.O);
Latency=zeros(M.Data.C,M.Data.G,M.Data.O);
MM=zeros(Zn,M.Data.G,M.Data.C,M.Data.O)-1; % add -1 to remind bad data


for i=1:M.Data.E
    t=M.Experiment.Event.Log(i,1);
    z=M.Experiment.Event.Log(i,2);
    o=M.Experiment.Event.Log(i,3);
    c=M.Experiment.Event.Log(i,4);
    n=c2n(c);
    
    for g=1:M.Data.G
        if M.Data.Sort.aConc(c)
            % modified by Elden @ 9/29/2011 to accomodate unequal zone width
            Sorted((1:(Z(z,2)-Z(z,1)+1))+(n-1)*Zn,g,o)=M.Data.Process.Processed(Z(z,1):Z(z,2),g,t);
        end
        Peak(c,g,o)=M.Data.Process.ZPeak(z,g,t);
        PeakWidth(c,g,o)=M.Data.Process.ZPeakWidth(z,g,t);
        Rise(c,g,o)=M.Data.Process.ZRise(z,g,t);
        Fall(c,g,o)=M.Data.Process.ZFall(z,g,t);
        Area(c,g,o)=M.Data.Process.ZArea(z,g,t);
        Latency(c,g,o)=M.Data.Process.ZLatency(z,g,t);
        
        % modified by Elden @ 9/29/2011 to accomodate unequal zone width
        MM(1:Z(z,2)-Z(z,1)+1,g,c,o)=M.Data.Process.Processed(Z(z,1):Z(z,2),g,t);
    end
end

vConc=M.Data.Sort.aConc;
vGlom=M.Data.Sort.rGlom(M.Data.Sort.aGlom(M.Data.Sort.rGlom));
vOdor=M.Data.Sort.rOdor(M.Data.Sort.aOdor(M.Data.Sort.rOdor));

M.Data.Sort.Sorted=Sorted(:,vGlom,vOdor);
M.Data.Sort.Peak=Peak(vConc,vGlom,vOdor);
M.Data.Sort.PeakWidth=PeakWidth(vConc,vGlom,vOdor);
M.Data.Sort.Rise=Rise(vConc,vGlom,vOdor);
M.Data.Sort.Fall=Fall(vConc,vGlom,vOdor);
M.Data.Sort.Area=Area(vConc,vGlom,vOdor);
M.Data.Sort.Latency=Latency(vConc,vGlom,vOdor);

M.Data.Sort.MM=MM(:,vGlom,vConc,vOdor);