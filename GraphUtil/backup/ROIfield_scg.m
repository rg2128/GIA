function [X Y A]=ROIfield(M,I,Option)
% ROIfield Function to map glomeruli intensity values to two dimensional
% glomeruli coordinate field
%
% Requirements: nlinfit function in the Statistics Toolbox
% 
% Inputs: M = Project Memory Structure  
%         I = Glomeruli Intensity vector
%         Option = Data set selection 0: Processed / 1: Sorted
%
% Algorithm: Generate a two dimensional spatial map of glomeruli
%            intensities using a gaussian distribution and fft convolution
%
% Output: 3 variables
%         X = X axis in um
%         Y = Y axis in um
%         A = Glomeruli Intensity Map
%
% Copyright 2009 Stephen Gradwohl
% send comments to SGradwohl@gmail.com
% Version 1.0    09/06/2009

if Option
    ROI=M.Data.ROI(M.Data.Sort.vGlom,:);    % Use Sorted glomeruli set
else
    ROI=M.Data.ROI;                         % Use Processed glomeruli set
end

Lx=cell2mat(M.Project.ROI(3));              % X pixel #
Ly=cell2mat(M.Project.ROI(4));              % Y pixel #
Mx=2;                                       % Pixel Multiplier
a=3*Mx;                                     % Gaussian Std deviation
S=10*Mx;                                    % Border Padding
SF=cell2mat(M.Project.ROI(5));              % Scaling Factor(um/pixel)

Nx=Lx+(Mx-1)*(Lx-1);                        % X axis length
Ny=Ly+(Mx-1)*(Ly-1);                        % Y axis length

X=linspace(1,Lx,Nx);
Y=linspace(1,Ly,Ny);

Xc=round((Lx+(Mx-1)*(Lx-1))/2);             % X center coordinate
Yc=round((Ly+(Mx-1)*(Ly-1))/2);             % Y center coordinate

Gx=exp(-((X-X(Xc))/a).^2);
Gy=exp(-((Y-Y(Yc))/a).^2);

G=transpose(Gx)*Gy;                         % Gaussian distribution

ROIg=ROI+(Mx-1)*(ROI-1);
F=zeros(Nx,Ny);                             % Glomeruli location

for g=1:sum(M.Data.Sort.aGlom(:))
    F(ROIg(g,1),ROIg(g,2))=I(g);            % Assign glomeruli intensity value
end

% Add padding to fields
Gs=zeros(Nx+2*S,Ny+2*S);
Fs=zeros(Nx+2*S,Ny+2*S);
Gs(S+1:S+Nx,S+1:S+Ny)=G;
Fs(S+1:S+Nx,S+1:S+Ny)=F;

% Convolution
fftGs=fft2(fftshift(Gs));
fftFs=fft2(flipud(rot90(Fs)));
As=ifft2(fftFs.*fftGs);

% Remove padding from fields
A=As(S+1:S+Nx,S+1:S+Ny);

% Axis Vectors in um
X=linspace(0,(Lx-1)*SF,Lx+(Mx-1)*(Lx-1));
Y=linspace(0,(Ly-1)*SF,Ly+(Mx-1)*(Ly-1));