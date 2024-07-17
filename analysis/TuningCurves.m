function [M] = TuningCurves(M)

[C G O]=size(M.Data.Sort.Peak);

%% Generate Odorant Tuning Curves
Odd(:,1)=1:2:G;
Even(:,1)=2:2:G;
Even=flipud(Even);
S=[Odd;Even];

A=M.Data.Sort.Peak;
Peak=zeros(C,G);
Tuning=zeros(C,G,O);

for o=1:O
    for c=1:C
        Peak(c,:)=sort(A(c,:,o));
    end
    Tuning(:,:,o)=Peak(:,S);
end

M.Data.Analysis.Tuning.Odor=Tuning;

clear Odd Even S

%% Generate Glomeruli Tuning Curves
Odd(:,1)=1:2:O;
Even(:,1)=2:2:O;
Even=flipud(Even);
S=[Odd;Even];

A=permute(M.Data.Sort.Peak,[1 3 2]);
Peak=zeros(C,O);
Tuning=zeros(C,O,G);

for g=1:G
    for c=1:C
        Peak(c,:)=sort(A(c,:,g));
    end
    Tuning(:,:,g)=Peak(:,S);
end

M.Data.Analysis.Tuning.Glom=Tuning;
