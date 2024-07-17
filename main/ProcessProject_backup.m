function [M] = ProcessProject(M)

H.wB=waitbar(0,'Project is being Processed');

Raw=M.Data.Raw;
Settings=M.Process.S;
D=M.Process.D;
Fs=cell2mat(M.Project.Info(5,2));
Z=M.Experiment.Zone.Duration;

Processed=Raw;

ZPeak=zeros(M.Data.Z,M.Data.G,M.Data.T);
ZPeakWidth=zeros(M.Data.Z,M.Data.G,M.Data.T);
ZRise=zeros(M.Data.Z,M.Data.G,M.Data.T);
ZFall=zeros(M.Data.Z,M.Data.G,M.Data.T);
ZArea=zeros(M.Data.Z,M.Data.G,M.Data.T);
ZLatency=zeros(M.Data.Z,M.Data.G,M.Data.T);

for t=1:M.Data.T
    for g=1:M.Data.G
        S=Settings(g,:,t);
        % Set Active Settings
        aS=zeros(10,1);
        if S(1)
            aS(1)=S(2); 
        else
            aS(1)=D(1); 
        end
        if S(3)
            aS(2)=S(4);
            aS(3)=S(5);
            aS(4)=S(6);
        else
            aS(2)=D(2);
            aS(3)=D(3);
            aS(4)=D(4);
        end
        if S(7)
            aS(5)=S(8);
            aS(6)=S(9);
        else
            aS(5)=D(5);
            aS(6)=D(6);   
        end
        if S(10)
            aS(7)=S(11);
            aS(8)=S(12);
            aS(9)=S(13);
            aS(10)=S(14);
        else
            aS(7)=D(7);
            aS(8)=D(8);
            aS(9)=D(9);
            aS(10)=D(10);
        end
                
        [y yR yS yB P PeakData PeakTimes]=ProcessF(Raw(:,g,t),Fs,aS,Z);
        
        for z=1:M.Data.Z
            n=find(PeakData(:,1)>=Z(z,1) & PeakData(:,1)<=Z(z,2));      % The number of peaks in a given Zone
            if isempty(n)    
            else
                for i=1:length(n)
                    % The largest peak is used
                    if PeakData(n(i),3)>ZPeak(z,g,t)
                        ZPeak(z,g,t)=PeakData(n(i),3);
                        ZPeakWidth(z,g,t)=PeakData(n(i),4);
                        ZRise(z,g,t)=PeakData(n(i),5);
                        ZFall(z,g,t)=PeakData(n(i),6);
                        ZArea(z,g,t)=PeakData(n(i),7);
                        ZLatency(z,g,t)=(PeakData(n(i),1)-Z(z,1))/Fs;
                    end
                end
            end
        end
        Processed(:,g,t)=y;
        waitbar(t/M.Data.T,H.wB)
    end
end

M.Data.Process.Processed=Processed;
M.Data.Process.ZPeak=ZPeak;
M.Data.Process.ZPeakWidth=ZPeakWidth;
M.Data.Process.ZRise=ZRise;
M.Data.Process.ZFall=ZFall;
M.Data.Process.ZArea=ZArea;
M.Data.Process.ZLatency=ZLatency;

close(H.wB)
