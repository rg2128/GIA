function SF=SizeFilter(Nx,Ny,r)

%SizeFilter returns a two dimension Nx X Ny array with
%expanded size of the point. The size is specified by the diameter in terms
%of pixels, r.
SF=zeros(Nx,Ny);
[X, Y]=meshgrid(((1:Nx)-round(Nx/2)),(1:Ny)-round(Ny/2));
[THETA,R]=cart2pol(X,Y);

[x y]=find(R<=r);
for i=1:length(x)
SF(x(i), y(i))=1;
end


