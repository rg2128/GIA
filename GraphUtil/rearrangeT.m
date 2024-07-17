function Tout=rearrangeT(Tin,mode)
%reassign cluster number by giving the higher cluster number to the cluster
%with the fewest members
%Mode is the sorting mode. Default='ascend'
if nargin<2
    mode='ascend';
end

Tl=length(Tin);
umem=unique(Tin);l=length(umem);
mcount(1:l)=0;Tlist(Tl,l)=0;
for i=1:l
    Tlist(:,i)= Tin==umem(i);
    mcount(i)=length(find(Tin==umem(i)));
end
[rm idx]=sort(mcount,mode);

Tr=Tlist(:,idx);
for i=1:l
    To(:,i)=Tr(:,i)*i;
end
Tout=sum(To,2);

