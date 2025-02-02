function Z = ChooseColor2(T,i)


ZT3 = [
8	2
9	3
4	4
20	8
1	6
2	7
17	5
23	9
15	10
18	11
21	15
5	16
11	17
14	18
16	14
7	21
22	20
13	13
10	22
19	26
12	24
6	27
3	29
];

ZT1=[
 9	1
15	2
5	3
29	4
1	5
18	6
13	7
23	8
17	9
19	10
3	11
4	12
21	13
20	14
24	15
25	16
28	17
16	18
2	19
7	20
8	21
30	22
22	23
26	24
10	25
31	26
27	27
11	28
14	29
6	30
12	31
];

ZT2=[
11	1
24	2
7	4
22	9
12	6
9	7
4	8
10	11
18	10
26	5
14	13
17	15
28	14
8	17
20	21
1	24
13	22
25	18
21	19
3	25
2	20
5	26
23	27
15	23
16	28
27	29
19	30
6	31    
];

switch i
    case 1
        ZT=ZT1;
    case 2
        ZT=ZT2;
    case 3
        ZT=ZT3;        
end
    
%% 1-1 correspondence
load('My31color.mat','My31Color');
m = length(T);
Z = zeros(m,3);
for i=1:m
    tLabel = T(i);
    ind = find(ZT(:,1)==tLabel);
    if isempty(ind)
        error('sth wrong');
    end
    Z(i,:) = My31Color(ZT(ind,2),:);
end   