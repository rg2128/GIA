function varargout = GIAcompare2(varargin)
% GIACOMPARE2 M-file for GIAcompare2.fig
%      GIACOMPARE2, by itself, creates a new GIACOMPARE2 or raises the existing
%      singleton*.
%
%      H = GIACOMPARE2 returns the handle to a new GIACOMPARE2 or the handle to
%      the existing singleton*.
%
%      GIACOMPARE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIACOMPARE2.M with the given input arguments.
%
%      GIACOMPARE2('Property','Value',...) creates a new GIACOMPARE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GIAcompare2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GIAcompare2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GIAcompare2

% Last Modified by GUIDE v2.5 20-Jul-2010 13:59:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIAcompare2_OpeningFcn, ...
                   'gui_OutputFcn',  @GIAcompare2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GIAcompare2 is made visible.
function GIAcompare2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIAcompare2 (see VARARGIN)

set(handles.OptionOk,'Enable','Off');

load('NewOdorDB.mat');
handles.data.odorDB = odorDB; 
handles.data.CAS = CAS;
handles.data.opt1 = load('optimizedDescriptors.mat','optimizedDescriptors'); 
handles.data.opt2 = load('optimizedDescriptors-Mainland.mat','optimizedDescriptors');

handles.data.cproj = 0;
handles.output = [];
guidata(hObject,handles);

% UIWAIT makes GIAcompare2 wait for user response (see UIRESUME)
uiwait;


% --- Outputs from this function are returned to the command line.
function varargout = GIAcompare2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);

% --- Executes on button press in OptionOk.
function OptionOk_Callback(hObject, eventdata, handles)
% hObject    handle to OptionOk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.data.cproj==0
    return;
end
handles = CollectOptions(handles);
%% independence test and clustering
[theirpd ourpd countNP saveAbr] = Compute2Distibution(handles.data,handles.option);
% figure;scatter(theirpd,ourpd);
% independence
[mDif hFig] = mean8medianNxNy(theirpd,ourpd,20,20);
[dummy hFig] = TestIndependence(theirpd,ourpd,20,20);
% linear correlation coefficient
r = corr(ourpd',theirpd');
fprintf('r=%3.2f\n',r);
% save independence test graph
if handles.option.AutoSave
    param = [handles.option.Res.Rep '-' handles.option.Res.Pre '-'...
             handles.option.Res.Pca '-' handles.option.Res.Dis '-'...    
             handles.option.Des.Rep '-' handles.option.Des.Pre '-'...
             handles.option.Des.Pca '-' handles.option.Des.Dis '-'...    
            ];
    filename1 = fullfile(handles.data.pDir,[param '.jpg']);    
    print(hFig,'-cmyk','-djpeg',filename1);     
    filename2 = fullfile(handles.data.pDir,[param '.fig']);
    saveas(hFig,filename2);
end
handles.output = handles.data;
guidata(hObject,handles);
uiresume;

% --- Executes on button press in OptionQuit.
function OptionQuit_Callback(hObject, eventdata, handles)
% hObject    handle to OptionQuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = [];
guidata(hObject,handles);
uiresume;


function SetDir_Callback(hObject, eventdata, handles)
%% to record all valid project folders under a designated directory
%  a project is valid if it has Project.mat
tmp1 = uigetdir('L:\Lab Member data files\Qiang\bulb imaging\GIAProccessed\Pooled data for similarity with distance compare');
if tmp1==0
    return;
end
ProjectsDir = {};
OurCAS = {};
OurAbr = {};
OurPeak = {};
tmp2 = dir(tmp1);
for i=1:length(tmp2)
    if tmp2(i).isdir==0 || strcmp(tmp2(i).name,'.') || strcmp(tmp2(i).name,'..')
        continue;
    end
    tDir = fullfile(tmp1,tmp2(i).name);           
    toLoad1 = fullfile(tDir,'Project.mat');
    if exist(toLoad1,'file')==0
        continue;
    end    
    disp(tDir);
    %% 
    ProjectsDir{end+1} = tDir;
    load(toLoad1,'Experiment','Data');
    OurCAS{end+1} = Experiment.Odor.CasNumber(Data.Sort.vOdor);    
    OurAbr{end+1} = Experiment.Odor.Abr(Data.Sort.vOdor);    
    OurPeak{end+1} = permute(Data.Sort.Peak,[3 2 1]);
end
handles.data.cproj = length(ProjectsDir);
handles.data.ProjectsDir = ProjectsDir;
handles.data.pDir = tmp1;
handles.data.OurAbr = OurAbr;
handles.data.OurCAS = OurCAS;
handles.data.OurPeak = OurPeak;
disp(sprintf('total %d projects collected!',handles.data.cproj));
set(handles.OptionOk,'Enable','On');
guidata(hObject,handles);

function [theirpd ourpd countNP saveAbr] = Compute2Distibution(data,option)
%ExcludeAbrList = {'HXH','VAH','HPO','HPH','HXO','MBH','PTO','OCH','BTH','IVAH','PPH','BTN','BBZ','TMBH','ACEO'};
%ExcludeAbrList = {'MAE' 'BAE' 'IAA' 'AA' 'FCTE' 'MPE' 'IPBE' 'BBE' 'ABE''NBE' 'EBE' 'IBBE' 'VBE' 'MVE' 'ETE' 'IPTE' 'MCE'};
%ExcludeAbrList = {'MAE' 'BAE' 'IAA' 'AA' 'FCTE' 'MPE' 'IPBE' 'BBE' 'ABE' 'NBE' 'EBE' 'IBBE' 'VBE' 'MVE' 'ETE' 'IPTE' 'MCE' 'HXH','VAH','HPH','MBH','OCH','BTH','IVAH','PPH','TMBH'};
ExcludeAbrList = {};
%% helper function to compute the 2 pdist distribution
ourpd = [];
theirpd = [];
countNP = [];
saveAbr = {};
for z=1:data.cproj
    tOurCAS = data.OurCAS{z};
    tOurAbr = data.OurAbr{z};
    [indToExclude, dummy] = ismember(tOurAbr,ExcludeAbrList);
    [indHasDesc, OurCasLoc] = ismember(tOurCAS,data.CAS);
    tOurPeak = data.OurPeak{z};
    if size(tOurPeak,3)~=3
        % skip this project if it has only 1 conc.
        continue;
    end
    %% representation
    switch option.Res.Rep
        case 'AllC'
            tmp = tOurPeak(:,:);
        case 'Con1'
            tmp = tOurPeak(:,:,1);
        case 'Con2'
            tmp = tOurPeak(:,:,2);
        case 'Con3'
            tmp = tOurPeak(:,:,3);
    end
    indResponse = sum(tmp,2) > eps;
    OurRep = tmp(indHasDesc & indResponse & ~indToExclude,:); 
    OdorAbr = tOurAbr(indHasDesc & indResponse & ~indToExclude);
    saveAbr{end+1} = OdorAbr;
    %
    tmp = data.odorDB;
    tmp = tmp(OurCasLoc(indHasDesc & indResponse & ~indToExclude),:);
    switch option.Des.Rep
        case 'Full'
            TheirRep = tmp;
        case 'Opt40'
            TheirRep = tmp(:,data.opt1.optimizedDescriptors);
        case 'Opt20'
            TheirRep = tmp(:,data.opt2.optimizedDescriptors);            
    end
    
    OurPd = ComputePd(OurRep,option.Res);
    TheirPd = ComputePd(TheirRep,option.Des);  
    countNP = [countNP length(OurPd)];
    ourpd = [ourpd OurPd];
    theirpd = [theirpd TheirPd];
    
    
    %% odor dendrogram by HAC
    hFig1 = figure('Position',[30 30 600 960]);whitebg('w');            
    hden1 = dendrogram(linkage(OurPd,option.Res.Linkage),0,...
        'orientation','right','labels',OdorAbr);
    set(gca,'YDir','reverse','FontWeight','bold','FontSize',8,'TickLength',[0 0]);
    set(hden1,'LineWidth',2,'Color','k')
    % save
    if option.AutoSave
        param = [option.Res.Rep '-' option.Res.Pre '-'...
                 option.Res.Pca '-' option.Res.Dis '-'...    
                 option.Res.Linkage];
        filename1 = fullfile(data.ProjectsDir{z},[param '.jpg']);    
        print(hFig1,'-cmyk','-djpeg',filename1);     
        filename2 = fullfile(data.ProjectsDir{z},[param '.fig']);
        saveas(hFig1,filename2);         
    end
    close(hFig1);

    hFig2 = figure('Position',[30 30 600 960]);whitebg('w');
    hden2 = dendrogram(linkage(TheirPd,option.Des.Linkage),0,...
        'orientation','right','labels',OdorAbr);
    set(gca,'YDir','reverse','FontWeight','bold','FontSize',8,'TickLength',[0 0]);
    set(hden2,'LineWidth',2,'Color','k')            
    % save
    if option.AutoSave
        param = [option.Des.Rep '-' option.Des.Pre '-'...
                 option.Des.Pca '-' option.Des.Dis '-'...    
                 option.Des.Linkage];
        filename1 = fullfile(data.ProjectsDir{z},[param '.jpg']);    
        print(hFig2,'-cmyk','-djpeg',filename1);     
        filename2 = fullfile(data.ProjectsDir{z},[param '.fig']);
        saveas(hFig2,filename2);
    end
    close(hFig2);
end


% --- Executes on button press in Optimize.
function Optimize_Callback(hObject, eventdata, handles)
% hObject    handle to Optimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.data.cproj==0
    return;
end
handles = CollectOptions(handles);
[historyCor,bestSet] = FindMaxCorr(handles.data,handles.option);
handles.data.historyCor = historyCor;
handles.data.bestSet = bestSet;
guidata(hObject,handles);
%uiresume;

function handles = CollectOptions(handles)
%% options
handles.option.Res.Rep = sub7(get(get(handles.ResRep,'SelectedObject'),'Tag'));
handles.option.Res.Pre = sub7(get(get(handles.ResPre,'SelectedObject'),'Tag'));
handles.option.Res.Pca = sub7(get(get(handles.ResPca,'SelectedObject'),'Tag'));
handles.option.Res.Dis = sub7(get(get(handles.ResDis,'SelectedObject'),'Tag'));
handles.option.Des.Rep = sub7(get(get(handles.DesRep,'SelectedObject'),'Tag'));
handles.option.Des.Pre = sub7(get(get(handles.DesPre,'SelectedObject'),'Tag'));
handles.option.Des.Pca = sub7(get(get(handles.DesPca,'SelectedObject'),'Tag'));
handles.option.Des.Dis = sub7(get(get(handles.DesDis,'SelectedObject'),'Tag'));
tmp = get(handles.ResLinkage,'String');
handles.option.Res.Linkage = tmp{get(handles.ResLinkage,'Value')};
tmp = get(handles.DesLinkage,'String');
handles.option.Des.Linkage = tmp{get(handles.DesLinkage,'Value')};
handles.option.AutoSave = get(handles.AutoSave,'Value');

function str2 = sub7(str1)
%% just to get substring from 7 to end
str2 = str1(7:end);

% --- Executes on button press in BatchOptimize.
function BatchOptimize_Callback(hObject, eventdata, handles)
% hObject    handle to BatchOptimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ResRepList = {'AllC','Con1','Con2','Con3'};
ResPreList = {'Raw','Zscore','Normr','Tiedrank','ZN','NZ'};
ResPcaList = {'Yes','No'};
ResDisList = {'Euc','Cos'};
DesPreList = {'Raw','Zscore','Normr','Tiedrank','ZN','NZ'};

allHistoryCor = {};
allBestSet = {};
allOption = {};
for i1=1:length(ResRepList)
    for i2=1:length(ResPreList)
        for i3=1:length(ResPcaList)
            for i4=1:length(ResDisList)
                for i5=1:length(DesPreList)
                    tOption.Res.Rep = ResRepList{i1};
                    tOption.Res.Pre = ResPreList{i2};
                    tOption.Res.Pca = ResPcaList{i3};
                    tOption.Res.Dis = ResDisList{i4};
                    tOption.Des.Pre = DesPreList{i5};
                    tOption.Des.Pca = 'No';
                    tOption.Des.Dis = 'Euc';
                    [historyCor,bestSet] = FindMaxCorr(handles.data,tOption);
                    % save
                    allOption{end+1} = tOption;
                    allHistoryCor{end+1} = historyCor;
                    allBestSet{end+1} = bestSet;
                    save('myrecord.mat','allOption','allHistoryCor','allBestSet');
                end
            end
        end
    end
end
