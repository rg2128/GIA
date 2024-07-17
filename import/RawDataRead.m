function [D] = RawDataRead(Directory,N)

H.wB=waitbar(0,'Project is being Loaded');

for t=1:N.T
    A=importdata(fullfile(Directory,[num2str(t) '.txt']));
    B(:,:,t)=A.data;
    waitbar(t/N.T,H.wB)
end

D.T=N.T;
D.G=length(B(1,:,1))-1;
D.O=N.O;
D.E=N.E;
D.C=N.C;
D.Z=N.Z;
D.Raw=B(:,2:D.G+1,:);

close(H.wB)
end