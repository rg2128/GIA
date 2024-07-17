function GF=GaussianFilter(Nx,Ny,Se,cutoff)

%GaussianFilter returns a two dimension Nx X Ny Gaussian Filter array with
%a standard deviation of Se.
%the value cutoff determines where the top cutoff is. This allows to
%generate a filter with a flat top. 
[X, Y]=meshgrid(((1:Nx)-round(Nx/2)),(1:Ny)-round(Ny/2));
[THETA,R]=cart2pol(X,Y);

if nargin<4
cutoff=0;
end
%Gaussian
EGauss=1/(2*pi*Se^2)*exp(-R.^2/(2*Se^2));

%flatten top
top=1/(2*pi*Se^2)*exp(-cutoff);
[x y]=find((EGauss>=top));
l=size(x);
for i=1:l
EGauss(x(i),y(i))=top;
end

GF=EGauss/top;