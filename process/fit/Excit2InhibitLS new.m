function [Y yExcit yInhib] = Excit2InhibitLS(X,T,a,b,c,d,e,f,tau)
%% the response model with logistic sigmod
%  param = [T a b c d e f tau]
%  tau: delay of inhibition
%  T: the time rising to peak for excit, usually the duration of odor on
%  usage: Y = ExcitAndInhibit(0:8000,10,0.002,0.006,0.3,0.002,200,2000);
%  Elden @ May 26 2010

if ~isvector(X)
    error('debug ExcitAndInhibit.m: X must be a vector');
end
% consider yExcit(1) = a/11 a good value to start
% solve exp(-b*(1-tauPrime))=10
tauPrime = 1+log(10)/b;
%
P = a/(1+exp(-b*(T-tauPrime)));
V = -d/(1+exp(-e*T));
%
TT = length(X);
yExcit = zeros(size(X));
yInhib = zeros(size(X));
% rising
for i=1:TT
    t = X(i);    
    if t<=T
        yExcit(i) = a /(1+ exp(-b*(t-tauPrime)));
%        yExcit(i) = a /(1+ exp(-b*t));
    else
        yExcit(i) = P*exp(-c*(t-T));
    end
    if t > tau
        if t <= T+tau
            yInhib(i) = -d/(1+exp(-e*(t-tau)));
        else
            yInhib(i) = V*exp(-f*(t-tau-T));
        end
    else
        yInhib(i) = 0;
    end
end
Y = yExcit + yInhib;   

return;
