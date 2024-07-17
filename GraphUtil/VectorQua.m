function y = VectorQua(x,N)
if nargin<2
    x = [0.1 0.2 0.18 0.19 0.3 0.24]
    N = 2
end
mx = max(x);
mn = min(x);
width = (mx-mn)/N;
for i= 1:N
BinCenter(i) = mn+ (i-0.5)*width;
end
for i=1:length(x)
xx = repmat(x(i),[1 N]);
xDif = abs(xx-BinCenter);
[dummy Ind] = min(xDif);
x(i) = BinCenter(Ind);
end
y = x;