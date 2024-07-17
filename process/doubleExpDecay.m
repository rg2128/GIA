function F = doubleExpDecay(T,S)
%% f = S(1)+S(2)*exp(-t/S(3))+S(4)*exp(-t/S(5))
%  S is the 5-parameter
%  Elden @ May 6 2010
if ~isvector(T)
    error('T need to be a vector');
end
if ~isvector(S) || length(S)~=5
    error('S need to be a 5-element vector');
end
%% calculation
F = zeros(size(T));
for i=1:length(T)
    t = T(i); 
    f = S(1)+S(2)*exp(-t/S(3))+S(4)*exp(-t/S(5));
    F(i) = f;
end