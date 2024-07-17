function [yFitPiece,NewFit] = ProcessZone(ySignalPiece,method,OldFit,T)
%% To process a zone only
%  3 Inputs:
%  ySignalPiece: to fit a zone piece from ySignal
%  method: handles.actPar(6)
%  MyFit: the strucutre of fit parameters
%  2 Outputs:
%  yFitPiece: 
%  NewFit: the updated structure
%
%  Elden Yu @ Jun 7 2010

% T = 18;

if method~=1 && method~=2 && method~=3
    error('debug: wrong method!');
end

%% 
yFitPiece = ySignalPiece;
NewFit = OldFit;
if method==1, return;end


%% fitting
xPiece = 1:length(ySignalPiece);
if OldFit.autofit
    if method==2
        OldFit.lb = [OldFit.lb(1:2) OldFit.lb(4:8)];
        OldFit.ub = [OldFit.ub(1:2) OldFit.ub(4:8)];        
    end
    % fit options
    opt = fitoptions(...
                'METHOD','nonlinearLeastSquares',...
                'Algorithm','Trust-Region',...
                'Lower',OldFit.lb,...
                'Upper',OldFit.ub,...
                'startPoint', (OldFit.lb+OldFit.ub)/2);
    if method==2
        modelFun = 'Excit2Inhibit(X,T,a,b,c,d,e,tau,f)';    
    else
        modelFun = 'Excit2InhibitLS(X,T,a,b,tau0,c,d,e,tau,f)';
    end
    ft = fittype(modelFun,'problem','T','independent','X','dependent','Y','options',opt);    
    ff = fit(xPiece',ySignalPiece,ft,'problem',T);
    if method==2 
        NewFit.auto = [ff.a,ff.b,      0,ff.c,ff.d,ff.e,ff.tau,ff.f];
    else
        NewFit.auto = [ff.a,ff.b,ff.tau0,ff.c,ff.d,ff.e,ff.tau,ff.f];
    end
    actFit = NewFit.auto;
%    actFit = (OldFit.lb+OldFit.ub)/2;
else
    actFit = OldFit.manual;
end

%% predict
if method==2
    [yFitPiece dummy1 dummy2] = Excit2Inhibit(xPiece',T,actFit(1),actFit(2),actFit(4),actFit(5),actFit(6),actFit(7),actFit(8));
else
    [yFitPiece dummy1 dummy2] = Excit2InhibitLS(xPiece',T,actFit(1),actFit(2),actFit(3),actFit(4),actFit(5),actFit(6),actFit(7),actFit(8));
end             

return;
