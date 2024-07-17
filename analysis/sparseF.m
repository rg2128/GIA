function [S] = sparseF(X)
N=length(X);
S=(1-(sum(X/N)^2/sum(X.^2/N)))/(1-(1/N));