function saveRFmovie(M,GlomN,Tv)
mov=DynamicRFmovie(M,GlomN,Tv);

PathName = uigetdir('c:\');
FileName=strcat('RF',M.Project.Folder,'Glom#',num2str(GlomN),'.avi');
movie2avi(mov,strcat(PathName,'\',FileName),'compression','Cinepak')
close