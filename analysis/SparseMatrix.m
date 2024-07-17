function [M] = SparseMatrix(M)

[C G O]=size(M.Data.Sort.Peak);

%% Generate Glomeruli Sparness Matrix

A=M.Data.Sort.Peak;
SparseM=zeros(C,O);

for o=1:O
    for c=1:C
        SparseM(c,o)=sparseF(A(c,:,o));
    end
end

% i=isnan(SparseM);
% SparseM(i)=1;

M.Data.Analysis.Sparse.Odor=SparseM;

clear Odd Even S
%% Generate Odorant Sparness Matrix

A=permute(M.Data.Sort.Peak,[1 3 2]);
SparseM=zeros(C,G);

for g=1:G
    for c=1:C
        SparseM(c,g)=sparseF(A(c,:,g));
    end
end

% i=isnan(SparseM);
% SparseM(i)=1;

M.Data.Analysis.Sparse.Glom=SparseM;

clear Odd Even S
%% Generate Odor Sparness Matrix across Concentration for each glomerulus

A=permute(M.Data.Sort.Peak,[2 3 1]);
A=A(:,:);
SparseM(1:G)=0;

for g=1:G
        SparseM(c,g)=sparseF(A(g,:));
end

% i=isnan(SparseM);
% SparseM(i)=1;

M.Data.Analysis.Sparse.GlomAll=SparseM;

clear Odd Even S