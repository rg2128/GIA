function [Y yExcit yInhib] = Excit2Inhibit(X,T,a,b,c,d,e,tau,f)
%% the response model
%  param = [T a b c d e f tau]
%  tau: delay of inhibition
%  T: the time rising to peak for excit, usually the duration of odor on
%  usage: Y = ExcitAndInhibit(0:8000,10,0.002,0.006,0.3,0.002,200,2000);
%  Elden @ May 26 2010

if ~isvector(X)
    error('debug ExcitAndInhibit.m: X must be a vector');
end
%
P = a - a*exp(-b*T);
V = -d + d*exp(-e*T);
%
TT = length(X);
yExcit = zeros(size(X));
yInhib = zeros(size(X));
% rising
for i=1:TT
    t = X(i);    
    if t<=T
        yExcit(i) = a - a*exp(-b*t);
    else
        yExcit(i) = P*exp(-c*(t-T));
    end
    if t > tau
        if t <= T+tau
            yInhib(i) = -d+d*exp(-e*(t-tau));
        else
            yInhib(i) = V*exp(-f*(t-tau-T));
        end
    else
        yInhib(i) = 0;
    end
end
Y = yExcit + yInhib;   

return;
