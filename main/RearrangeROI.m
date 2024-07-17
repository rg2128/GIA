function [ROI,ind] = RearrangeROI(M,OrderMethod)
%% modified by Elden Yu @ 7/16/2010
if isfield(M.Data.Sort,'ROIapml')
    ROI = M.Data.Sort.ROIapml;
else
    ROI = ROI2apml(M.Data.ROI,M.Project.ROI);
end

%% rearrange
switch OrderMethod
    case 1
        [n ind]=sortrows(ROI,[2 1]);
    case 2
        [n ind]=sort(ROI(:,2));
    case 3
        [n ind]=sort(ROI(:,2),'descend');
    case 4
        [n ind]=sort(ROI(:,1));
    case 5
        [n ind]=sort(ROI(:,1),'descend');
    case 6
        ind = (1:M.Data.G)';
end