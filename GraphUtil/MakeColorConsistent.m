function MakeColorConsistent(hden,Z)
%% to correct dendrogram colors with scatter plot colors
%  Elden Yu 7/13/2010

%% collect frequency of each color in dendrogram 
DenColors = [];
DenColorCount = [];
for i=1:length(hden)
    tColor = get(hden(i),'Color');
    if isempty(DenColors)
        DenColors = tColor;
        DenColorCount(1) = 1;        
    else
        [TF,LOC] = ismember(tColor,DenColors,'rows');
        if TF
            DenColorCount(LOC) = DenColorCount(LOC) + 1;
        else
            DenColors = [DenColors;tColor];
            DenColorCount(end+1) = 1;
        end        
    end
end
disp('collected dendrogram color freq');

%% collect color freq in scatter plots
ScaColors = [];
ScaColorCount = [];
for i=1:size(Z,1)
    tColor = Z(i,:);
    if isempty(ScaColors)
        ScaColors = tColor;
        ScaColorCount(1) = 1;        
    else
        [TF,LOC] = ismember(tColor,ScaColors,'rows');
        if TF
            ScaColorCount(LOC) = ScaColorCount(LOC) + 1;
        else
            ScaColors = [ScaColors;tColor];
            ScaColorCount(end+1) = 1;
        end        
    end
end
disp('done with scatter color freq');

%% one-one correspondence
% remove black color from dendrogram color set
[TF,LOC] = ismember([0 0 0],DenColors,'rows');
if TF
    tmp = setdiff(1:length(DenColorCount),LOC);
    DenColors = DenColors(tmp,:);
    DenColorCount = DenColorCount(tmp);    
end

% now both should have the same number of colors
% I use sorting to do one-one correspondence
% It is problematic if color counts are very similar
[dummy1, sortInd1] = sort(DenColorCount,'descend');
[dummy2, sortInd2] = sort(ScaColorCount,'descend');
DenColorsSort = DenColors(sortInd1,:);
ScaColorsSort = ScaColors(sortInd2,:);

%% correction
for i=1:length(hden)
    tColor = get(hden(i),'Color');
    [TF,LOC] = ismember(tColor,DenColorsSort,'rows');
    if TF
        set(hden(i),'Color',ScaColorsSort(LOC,:));
    end
end
