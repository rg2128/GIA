function ROI = FlipROI(M1)

X(:,1)=1:cell2mat(M1.Project.ROI(3));
Y(:,1)=1:cell2mat(M1.Project.ROI(4));
Xr=flipud(X);
Yr=flipud(Y);


switch cell2mat(M1.Project.ROI(2))
    case 'APML'
        ROI(:,1)=M1.Data.ROI(:,1);
        ROI(:,2)=M1.Data.ROI(:,2);
    case 'APLM'
        ROI(:,1)=Xr(M1.Data.ROI(:,1));
        ROI(:,2)=M1.Data.ROI(:,2);
   	case 'PAML'
        ROI(:,2)=Yr(M1.Data.ROI(:,2));
        ROI(:,1)=M1.Data.ROI(:,1);
 	case 'PALM'
        ROI(:,1)=Xr(M1.Data.ROI(:,1));
        ROI(:,2)=Yr(M1.Data.ROI(:,2));
end

