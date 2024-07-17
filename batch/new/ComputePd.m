function OurPd = ComputePd(OurRep,option)
%% compute pairwise distance
%  data: N*P matrix
%  option: struct of parameters
    
%% preprocessing
switch option.Pre
    case 'Raw'
        OurPre = OurRep;
    case 'Zscore'
        OurPre = zscore(OurRep);
    case 'Normr'
        OurPre = normr(OurRep);
    case 'Tiedrank'
        OurPre = tiedrank(OurRep);
    case 'ZN'
        OurPre = zscore(normr(OurRep));
    case 'NZ'
        OurPre = normr(zscore(OurRep));
end
    
%% PCA or not
switch option.Pca
    case 'Yes'    
        [dummy,score,latent]= princomp(zscore(OurPre));
        tmp = find((cumsum(latent)./sum(latent))>0.8);            
        if tmp(1)<=1
            error('sth wrong with princomp');
        end
        OurPca = score(:,1:tmp(1)-1);
    case 'No'
        OurPca = OurPre;
end
    
%% distance
switch option.Dis
    case 'Euc'
        OurPd = pdist(OurPca,'euclidean');
    case 'Cos'
        OurPd = pdist(OurPca,'cosine');
end
