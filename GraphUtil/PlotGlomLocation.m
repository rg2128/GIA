G=sum(M.Data.Sort.aGlom);

Lx=cell2mat(M.Project.ROI(3));              % X pixel #
Ly=cell2mat(M.Project.ROI(3));              % Y pixel #
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)
                   
% X=linspace(0,(Lx-1)*SF,Lx);                 % X axis length vector
% Y=linspace(0,(Ly-1)*SF,Ly);                 % Y axis length vector
ROI=FlipROI(M);
ROIx=ROI(M.Data.Sort.vGlom,1);              % Sorted ROI x coordinates
ROIy=ROI(M.Data.Sort.vGlom,2);  

%Loc_ID=sort(M.Data.Sort.vGlom);

figure ('position',[5 5 600 600])
for i=1:G
    H=scatter(ROIx(i),ROIy(i),200,'ob'); hold on
    H=text(ROIx(i)-5,ROIy(i),[num2str(M.Data.Sort.vGlom(i)) '/' num2str(i)]);
end
title(strcat('Glomerular ID location/',M.Project.Folder))
axis ij