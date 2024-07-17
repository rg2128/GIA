I=imread('GIA6-EuclDistSim-Clust10.jpg');

IG=rgb2gray(I);
%IR=I(:,:,1);IG=I(:,:,2);IB=I(:,:,3);

figure,imshow(I);
figure,imshow(IG);

% se = strel('disk',5);
% I_opened = imopen(I,se);
% figure, imshow(I_opened,[])

% IN=imnoise(I);
% imshow(IN);

PSF = fspecial('gaussian',[30 30],5);

%Create a simulated blur in the image.

Blurred = imfilter(IG,PSF,'circular','conv');
figure, imshow(Blurred)