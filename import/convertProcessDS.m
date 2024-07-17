function [newD,newS] = convertProcessDS(oldD,oldS)
%% to convert the old style Process.D and Process.S into new style
%  in old style, D is 10*1 vector, S is size (#g,14,#t) matrix
%  in new style, D is 17*1 vector, S is size (#g,17,#t) matrix
%  Elden Yu @ May 21 2010
%
%  in latest style, D is 42*1 vector, S is size (#g,42,#t) matrix
%  two step process to allow data compatibility
%  converting from 17 to 42 to allow 1+3*8 more fitting parameters
%  Elden Yu @ Jun 1 2010
%  
%  Now I found the 1+3*8 fitting parameters is t/g/zone specific
%  I added another function in addMyFit.m to deal with it
%  so here D/S should get back to 17D
%  In summary,
%  newD is project specific,
%  newS is t/g specific, 
%  myFit is t/g/zone specific
%  Elden Yu @ Jun 3 2010
% 
%  one more way to estimate baseline
%  by modeling as exponentials with common time factor
%  so param 18,19,20 is the popup menu choice, inti v and time factor
%  Elden Yu @ Jun 21 2010

%% converting from 10 to 17 elements
if length(oldD)==10
    disp('converting 10-D style D,S to 20-D style');
    % converting D
    oldD = transpose(oldD);
    newD = [oldD(3:6) 0 1 oldD(7:10) 0 0 oldD(9:10) 1 0 0 1 0.1 0.1]';
    % converting S
    [nG,dummy,nT] = size(oldS);
    newS = zeros(nG,20,nT);
    tNewS = zeros(1,20);   
    for i=1:nG
        for j=1:nT
            tOldS = oldS(i,:,j);
            if tOldS(3)
                tNewS(1:2) = tOldS(5:6);
            else
                tNewS(1:2) = newD(1:2);
            end
            if tOldS(7)
                tNewS(3:4) = tOldS(8:9);
            else
                tNewS(3:4) = newD(3:4);
            end
            tNewS(5) = newD(5);
            tNewS(6) = newD(6);                
            if tOldS(10)
                tNewS(7:10) = tOldS(11:14);
            else
                tNewS(7:10) = newD(7:10);
            end
            tNewS(11:20) = newD(11:20);    
            newS(i,:,j) = tNewS(:);
        end
    end    
    disp('D/S converted');    
end

if length(oldD)==17
    if size(oldD,1)>1
        oldD = oldD';
    end
    newD = [oldD 1 0.1 0.1];
    [nG,dummy,nT] = size(oldS);    
    newS = zeros(nG,20,nT);
    for i=1:nG
        for j=1:nT
            newS(i,:,j) = [oldS(i,:,j) 1 0.1 0.1];
        end
    end    
end

return;
