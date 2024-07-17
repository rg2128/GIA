function ROIapml = ROI2apml(ROIdata,ROIinfo)
%% convert raw ROI coordinates into APML style by a kind of flipping
%  for example, if 256 pixels, 1 change to 256
%  Elden Yu @ 7/16/2010

ROIapml = ROIdata;

X = (ROIinfo{3}:-1:1)';
Y = (ROIinfo{4}:-1:1)';

switch ROIinfo{2}
    case 'APML'
    case 'APLM'
        ROIapml(:,1)=X(ROIdata(:,1));
   	case 'PAML'
        ROIapml(:,2)=Y(ROIdata(:,2));
  	case 'PALM'
        ROIapml(:,1)=X(ROIdata(:,1));
        ROIapml(:,2)=Y(ROIdata(:,2));
end
