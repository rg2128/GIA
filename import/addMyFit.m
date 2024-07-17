function myFit = addMyFit(nt,ng,nz)
%% fitting parameters are zone specific
%  I decide to store 1+4*9
%  9 lowerbound, 9 upperbound, 9 auto, 9 manual + 1 checkbox indicator
%  Saved as a array struct of size {#t,#g,#zone}
%  each struct with following fields
%  lb: size 1*9 vector
%  ub: size 1*9 vector
%  auto: size 1*9 vector
%  manual: size 1*9 vector
%  autofit: 1/0
%  Elden Yu @ June 10 2010

%% add myFit
disp('adding Fit');    
defLb = [0    0.4  5   0    0  0.1 15   0];
defUb = [0.15 0.6 10 0.15 0.15 0.3 40 0.15];
defAuto = (defLb + defUb)/2;
defManual = defAuto;
defAutoFit = 1;
% 
tmpLb = cell(nt,ng,nz);
tmpUb = cell(nt,ng,nz);
tmpAuto = cell(nt,ng,nz);
tmpManual = cell(nt,ng,nz);
tmpAutoFit = cell(nt,ng,nz);
for i=1:nt
    for j=1:ng                
        for k=1:nz
            tmpLb{i,j,k} = defLb;
            tmpUb{i,j,k} = defUb;
            tmpAuto{i,j,k} = defAuto;
            tmpManual{i,j,k} = defManual;
            tmpAutoFit{i,j,k} = defAutoFit;
        end        
    end
end
myFit = struct('lb',tmpLb,'ub',tmpUb,'auto',tmpAuto,'manual',tmpManual,'autofit',tmpAutoFit);
disp('added Fit');

