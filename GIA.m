function varargout = GIA(varargin)
% GIA M-file for GIA.fig
%      GIA, by itself, creates a new GIA or raises the existing
%      singleton*.
%
%      H = GIA returns the handle to a new GIA or the handle to
%      the existing singleton*.
%
%      GIA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIA.M with the given input arguments.
%
%      GIA('Property','Value',...) creates a new GIA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GIA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GIA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GIA

% Last Modified by GUIDE v2.5 18-Jun-2010 10:28:02

% Begin initialization code - DO NOT EDIT
% disp('GIA.m called with the following parameters!');
% for i=1:nargin
%     if isempty(varargin{i})
%         disp('empty');
%     else
%         disp(varargin{i});
%     end
% end
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIA_OpeningFcn, ...
                   'gui_OutputFcn',  @GIA_OutputFcn, ...
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


% --- Executes just before GIA is made visible.
function GIA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIA (see VARARGIN)
handles.code.defaultPath = 'c:\GIA';
if isequal(exist(handles.code.defaultPath,'dir'),7)  
else
    mkdir(handles.code.defaultPath);
end
handles.code.recentMax = 5;
% load the recent project list if existing
if exist(fullfile(handles.code.defaultPath,'recentProject.mat'),'file')
    savedVar = load(fullfile(handles.code.defaultPath,'recentProject.mat'));
    savedRecent = savedVar.tmp;
    % got to remove those not actually existing (might be deleted manually)
    for i=1:length(savedRecent)
        if exist(fullfile(savedRecent{i},'Project.mat'),'file')
            if exist('validRecent','var')
                validRecent{end+1} = savedRecent{i};
            else
                validRecent{1} = savedRecent{i};
            end
        end
    end
    % if anything invalid, overwrite the saved file list
    if length(savedRecent)~=length(validRecent)
        tmp = validRecent;
        save(fullfile(handles.code.defaultPath,'recentProject.mat'),'tmp');
    end
    handles.code.recentProject = validRecent;
else
    handles.code.recentProject = [];
end
% set meanu items and Callbacks for these recent files
for i=1:length(handles.code.recentProject)
    tProject = handles.code.recentProject{i};
    hRecent = findobj('Label',tProject);
    if isempty(hRecent) % make sure only one copy occurs
        if i==1
            uimenu(handles.Project,'Label',tProject,'Separator','On');            
        else
            uimenu(handles.Project,'Label',tProject);
        end
        hRecent = findobj('Label',tProject);
        set(hRecent,'Callback',{@Recent_Callback,handles,tProject});
    end
end
% Temporary: Add all function paths
%%%%%%%%%%%

handles.flag.prj = 0;
set(handles.textProjectName,'String','No Project Open');

% Choose default command line output for GIA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GIA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GIA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function New_Callback(hObject, eventdata, handles)
% hObject    handle to New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Dir = GIAwNew(handles);
if ~isempty(Dir)
    CommonWorkOnLoading(hObject, handles, Dir);
end



% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Dir = uigetdir(handles.code.defaultPath);
if ~isequal(Dir,0)
    CommonWorkOnLoading(hObject, handles, Dir);
end

function Recent_Callback(hObject, eventdata, handles, Dir)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CommonWorkOnLoading(hObject, handles, Dir);


% --- Executes on button press in pushbuttonParameters.
function pushbuttonParameters_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    handles.M=GIAparameters(handles.M);
    guidata(hObject, handles);
else
    GIAmessage('title','Warning','message','Load Project File')
end

% --- Executes on button press in pushbuttonReview.
function pushbuttonReview_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    handles.M=GIAreview(handles.M);
    guidata(hObject, handles);
else
    GIAmessage('title','Warning','message','Load Project File')
end

% --- Executes on button press in pushbuttonProcess.
function pushbuttonProcess_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    pOv = get(get(handles.ProcessPOV,'SelectedObject'),'Tag');    
    handles.M=ProcessProject(handles.M,pOv);
    guidata(hObject, handles);
    SaveProject(handles)
else
    GIAmessage('title','Warning','message','Load Project File')
end


% --- Executes on button press in pushbuttonView.
function pushbuttonView_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    GIAview('Data',handles.M)
else
    GIAmessage('title','Warning','message','Load Project File')
end


% --- Executes on button press in pushbuttonRearrange.
function pushbuttonRearrange_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRearrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    if isfield(handles.M.Data,'Process')
        handles.M=GIArearrange(handles.M);
        guidata(hObject, handles);
    else
        GIAmessage('title','Warning','message','Process Project File')
    end
else
    GIAmessage('title','Warning','message','Load Project File')
end

% --- Executes on button press in pushbuttonAnalysis.
function pushbuttonAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    if isfield(handles.M.Data,'Sort')
        handles.M=TuningCurves(handles.M);
        display('Tuning Curves Analyzed')
        handles.M=SparseMatrix(handles.M);
        display('Sparse Matrix Analyzed')
        guidata(hObject, handles);
        SaveProject(handles)
        GIAmessage('title','Attention','message','Project Analyzed')
    else
        GIAmessage('title','Warning','message','Sort Project File')
    end
else
    GIAmessage('title','Warning','message','Load Project File')
end


% --- Executes on button press in pushbuttonPlots.
function pushbuttonPlots_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    if isfield(handles.M.Data,'Sort')
        GIAplots('Data',handles.M)
    else
        GIAmessage('title','Warning','message','Sort Project File')
    end
else
    GIAmessage('title','Warning','message','Load Project File')
end


% --------------------------------------------------------------------
function ClearProcess_Callback(hObject, eventdata, handles)
% hObject    handle to ClearProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    if isfield(handles.M.Data,'Process')
        handles.M.Data=rmfield(handles.M.Data,'Process');
        display('Processed Data Cleared')
        guidata(hObject, handles);
        SaveProject(handles)
    else
        GIAmessage('title','Warning','message','No Processed Data Available')
    end
else
    GIAmessage('title','Warning','message','Load Project File')
end

% --------------------------------------------------------------------
function ClearSort_Callback(hObject, eventdata, handles)
% hObject    handle to ClearSort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.flag.prj
    if isfield(handles.M.Data,'Sort')
        handles.M.Data=rmfield(handles.M.Data,'Sort');
        display('Sorted Data Cleared')
        guidata(hObject, handles);
        SaveProject(handles)
    else
        GIAmessage('title','Warning','message','No Sorted Data Available')
    end
else
    GIAmessage('title','Warning','message','Load Project File')
end

function SaveProject(handles)

Project=handles.M.Project;
Experiment=handles.M.Experiment;
Process=handles.M.Process;
Data=handles.M.Data;
save(fullfile(handles.M.Project.Folder,'Project.mat'),'Project','Experiment','Process','Data');
display('Project Saved');


function CommonWorkOnLoading(hObject,handles,Dir)
%%  called by new, load, recent file list
tmpFile = fullfile(Dir,'Project.mat');
if exist(tmpFile,'file')
    % 0. backup the old project file ONLY once
    %    so this new version won't erase old data
    tmpFileBackup = fullfile(Dir,'backupProject.mat');
    if ~exist(tmpFileBackup,'file')
        copyfile(tmpFile,tmpFileBackup);
    end      
    % 1. load M
    handles.M = load(tmpFile);
    % 2. set indicatior
    handles.flag.prj = 1;
    % 3. update handles.code.recentProject
    if isempty(handles.code.recentProject)
        handles.code.recentProject{1} = Dir;
    else
        % check whether it is same as one of existing
        isSame = 0;
        for i=1:length(handles.code.recentProject)
            if strcmp(Dir,handles.code.recentProject{i})
                isSame = 1;
                break;
            end
        end
        % same or not, different processing
        if isSame
            for j=i:length(handles.code.recentProject)-1
                handles.code.recentProject{j} = handles.code.recentProject{j+1};
            end
            handles.code.recentProject{end} = Dir;                
        else
            if length(handles.code.recentProject)==handles.code.recentMax
                for j=1:handles.code.recentMax-1
                    handles.code.recentProject{j} = handles.code.recentProject{j+1};
                end
                handles.code.recentProject{end} = Dir;
            else
                handles.code.recentProject{end+1} = Dir;
            end
        end
    end
    tmp = handles.code.recentProject;
    save(fullfile(handles.code.defaultPath,'recentProject.mat'),'tmp');
    % 4. correct handles.M.Project.Folder to contain absolute path
    if strcmp(handles.M.Project.Folder, Dir)==0
        handles.M.Project.Folder = Dir;
    end
    % 5. correct handles.M.Process from historical projects
    % so D and S is length 17
    %    fit is added
    if length(handles.M.Process.D)~= 20
        [newD,newS] = convertProcessDS(handles.M.Process.D,handles.M.Process.S);
        handles.M.Process.D = newD;
        handles.M.Process.S = newS;
    end
%    if ~isfield(handles.M.Process,'Fit')
        myFit = addMyFit(handles.M.Data.T,handles.M.Data.G,handles.M.Data.Z);
        handles.M.Process.Fit = myFit;      
%    end
    if ~isfield(handles.M.Experiment.Odor,'CasNumber')
        nOdor = length(handles.M.Experiment.Odor.Name);
        tmp = cell(nOdor,1);
        for i=1:nOdor
            tmp{i} = 'n/a';
        end
        handles.M.Experiment.Odor.CasNumber = tmp;
    end
    % 6. set static text in the figure
    Label=[handles.M.Project.Info{1,2},blanks(1),'@',blanks(1),Dir];        
    set(handles.textProjectName,'String',Label)                    
    % 7. for sharing data purpose
    guidata(hObject, handles);
else
    GIAmessage('title','Warning','message','Project File does not Exist')    
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
%% --- Executes when user attempts to close figure1.
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save the most recent projects into giaProfile.txt


% Hint: delete(hObject) closes the figure
delete(hObject);
