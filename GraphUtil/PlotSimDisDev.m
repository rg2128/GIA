function [NormDev NormDevr NormDevDiff DistAxis]=PlotSimDisDev(RALL, SIMALL,Dist,N)

%take data generated from GlomSimVdisAll.m in the form of RALL and SIMALL
%Dist: distance bin size
%Returns four sets of values
binx=round(max(RALL)/Dist);biny=binx;
SimX=[RALL' SIMALL']; 
[SimN,SimC]=hist3(SimX,[binx biny]);SimN=fliplr(SimN);SimN=flipud(SimN);
figure
imagesc(SimC{1,1},SimC{1,2},SimN);
l=length(RALL);

SimDisDev=zeros(binx,N);
rSimDisDev=zeros(binx,N);
SimRarray(binx,biny,10)=0;

    R=RALL(randperm(l));
    SimXr=[R' SIMALL'];
    [SimNr SimCr]=hist3(SimXr,[binx biny]);SimNr=fliplr(SimNr);SimNr=flipud(SimNr);
    SimRarray(:,:,1)=SimNr;
    SimNrSum=SimNr;
    
for i=2:N
    R=RALL(randperm(l));
    SimXr=[R' SIMALL'];
    [SimNr SimCr]=hist3(SimXr,[binx biny]);SimNr=fliplr(SimNr);SimNr=flipud(SimNr);
    SimRarray(:,:,i)=SimNr;
    SimNrSum=SimNrSum+SimNr;
end
    SimNrM=SimNrSum/N;
figure
imagesc(SimC{1,1},SimC{1,2},SimNrM);
diff=SimN-SimNrM;
figure;imagesc(SimC{1,1},SimC{1,2},diff)
SimNrDiff(N,binx)=0;
SimNDiff(N,binx)=0;
for i=1:N
SimNDiff(i,:)=sum(abs(SimN-SimRarray(:,:,i)));
SimNrDiff(i,:)=sum(abs(SimNrM-SimRarray(:,:,i)));
end

DistAxis=SimC{1,1};
%calculate using cumulative number of glomeruli
SimNsum=sum(SimNrM);
NormDev=cumsum(sum(SimNDiff))./(cumsum(SimNsum)*N);
NormDevr=cumsum(sum(SimNrDiff))./(cumsum(SimNsum)*N);
NormDevDiff=NormDev-NormDevr;
figure
plot(SimC{1,1},NormDev);
hold on
plot(SimC{1,1},NormDevr,'-r');
plot(SimC{1,1},NormDevDiff,'-g');
hold off

%calculate using the number of glomeruli within each bin
SimNsum=sum(SimNrM);
iNormDev=(sum(SimNDiff))./((SimNsum)*N);
iNormDevr=(sum(SimNrDiff))./((SimNsum)*N);
iNormDevDiff=NormDev-NormDevr;
figure
plot(SimC{1,1},iNormDev);
hold on
plot(SimC{1,1},iNormDevr,'-r');
plot(SimC{1,1},iNormDevDiff,'-g');
hold off
