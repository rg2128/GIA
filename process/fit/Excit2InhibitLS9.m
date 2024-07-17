function [Y yExcit yInhib] = Excit2InhibitLS(X,T,a,b,tau0,c,d,e,tau,f)
%% the response model with logistic sigmod
%  param = [T a b c d e f tau]
%  tau: delay of inhibition
%  T: the time rising to peak for excit, usually the duration of odor on
%  usage: Y = ExcitAndInhibit(0:8000,10,0.002,0.006,0.3,0.002,200,2000);
%  Elden @ May 26 2010

if ~isvector(X)
    error('debug ExcitAndInhibit.m: X must be a vector');
end
%
P = a/(1+exp(-b*tau0));
V = -d/(1+exp(-e*T));
%
TT = length(X);
yExcit = zeros(size(X));
yInhib = zeros(size(X));
% rising
for i=1:TT
    t = X(i);    
    if t<=T
        yExcit(i) = a /(1+ exp(-b*(t-tau0)));
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
