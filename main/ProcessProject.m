function [M] = ProcessProject(M,pov)

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
        %% prepare parameters               
        yRaw = M.Data.Raw(:,g,t);
        actPar = Settings(g,:,t);
        if actPar(6)==4
            actPar(6) = 3;
        end
        if actPar(6)==0
            actPar(6) = 1;
        end
        if isvector(actPar) % make row vector
            if size(actPar,1)>1
                actPar = actPar';
            end
        else
            error('debug: actPar must be vector');
        end
        Zone = M.Experiment.Zone.Duration;
        OdorOnOff = Zone;
        tmpLog = M.Experiment.Event.Log;
        for i=1:size(Zone,1)
            OdorOnOff(i,1) = tmpLog(tmpLog(:,1)==t & tmpLog(:,2)==i, 6);
            OdorOnOff(i,2) = tmpLog(tmpLog(:,1)==t & tmpLog(:,2)==i, 7);
        end
        fps = cell2mat(M.Project.Info(5,2));% frame per second
        oldFits = M.Process.Fit(t,g,:);
        
        %% compute
        [ySmooth, yBase, ySignal, yFit, RisItvl, DecItvl, newFits] ...
            = ProcessTrace(yRaw,actPar,Zone,OdorOnOff,fps,oldFits);

        [P, PeakData, PeakTimes,V, ValleyData, ValleyTimes] ...
            = PeakValley(yFit, actPar, Zone, fps, RisItvl, DecItvl);
        
        % use peak or valley data
        if strcmp(pov,'valley')
            PeakData = ValleyData;
        end
        
        for z=1:M.Data.Z
            n=find(PeakData(:,1)>=Zone(z,1) & PeakData(:,1)<=Zone(z,2));      % The number of peaks in a given Zone
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
        Processed(:,g,t)=yFit;
        waitbar((t*M.Data.G+g)/(M.Data.G*M.Data.T),H.wB)
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
