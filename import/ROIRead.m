function [D]=ROIRead(filename,Format)
ROIm=textread(filename,'%q');
Li=length(ROIm);
x(1:Li)=0;
y(1:Li)=0;
if strmatch(Format,'Old')==1   
    for i=1:Li
        X='';
        Y='';
        W='';
        H='';
        M=cell2mat(ROIm(i,:));
        Lj=length(M);
        Xswitch=false;
        Yswitch=false;
        Wswitch=false;
        Hswitch=false;
        for j=1:Lj
            if Xswitch == true
                X=strcat(X,M(j));
            end
            if Yswitch == true
                Y=strcat(Y,M(j));
            end
            if Wswitch == true
                W=strcat(W,M(j));
            end 
            if Hswitch == true
                H=strcat(H,M(j));
            end     
            if M(j) == 'x'
                Xswitch=true;
            end
            if M(j) == 'y'
                Yswitch=true;           
            end
            if M(j) == 'w'
                Wswitch=true;           
            end
            if M(j) == 'h'
                Hswitch=true;           
            end
            if M(j) == '.'
                Xswitch=false;
                Yswitch=false;
                Wswitch=false;
            end
            x(i)=str2double(X)+0.5*str2double(W);
            y(i)=str2double(Y)+0.5*str2double(H);
        end
    end
    D=transpose([x;y]);
end
if strmatch(Format,'New')==1 
    for i=1:Li
        X='';
        Y='';
        M=cell2mat(ROIm(i,:));
        Lj=length(M);
        Xswitch=false;
        Yswitch=false;
        for j=1:Lj
            if M(j) == '-'
                Xswitch=false;
            end
            if Xswitch == true
                X=strcat(X,M(j));
            end
            if Yswitch == true
                Y=strcat(Y,M(j));
            end
            if M(j) == 'O'
                Xswitch=true;
            end
            if M(j) == '-'
                Yswitch=true;           
            end
            x(i)=str2double(X);
            y(i)=str2double(Y);
        end
    end
    D=transpose([x;y]);   
end