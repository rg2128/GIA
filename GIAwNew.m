function varargout = GIAwNew(varargin)
% GIAWNEW M-file for GIAwNew.fig
%      GIAWNEW, by itself, creates a new GIAWNEW or raises the existing
%      singleton*.
%
%      H = GIAWNEW returns the handle to a new GIAWNEW or the handle to
%      the existing singleton*.
%
%      GIAWNEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIAWNEW.M with the given input arguments.
%
%      GIAWNEW('Property','Value',...) creates a new GIAWNEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GIAwNew_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GIAwNew_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GIAwNew

% Last Modified by GUIDE v2.5 14-May-2010 17:50:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIAwNew_OpeningFcn, ...
                   'gui_OutputFcn',  @GIAwNew_OutputFcn, ...
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


% --- Executes just before GIAwNew is made visible.
function GIAwNew_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIAwNew (see VARARGIN)

% check existing projects for a default project name
% how many projects with a default name there
n = 1;
giaHandles = varargin{1};
handles.defaultPath = giaHandles.code.defaultPath;
while exist(fullfile(handles.defaultPath,sprintf('project%d',n)),'dir')
    n = n+1;
end
set(handles.editProject,'string',sprintf('project%d',n));
% disable create button until the source is ready
set(handles.pushbuttonCreate,'Enable','off');
% Choose default command line output for GIAwNew
handles.output = hObject;
handles.flag=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GIAwNew wait for user response (see UIRESUME)
uiwait;


% --- Outputs from this function are returned to the command line.
function varargout = GIAwNew_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if handles.flag
    varargout{1} = handles.output;
else
    varargout{1} = [];
end
    
delete(hObject)



% --- Executes on button press in pushbuttonBrowse.
function pushbuttonBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Field=uigetdir(handles.defaultPath,'Pick a folder with source data');
if isequal(Field,0)
else
    % check if the folder has Parameters.xls, ROI.txt
    % leaving checking 1.txt ... N.txt in CreateProject.m
    if exist(fullfile(Field,'Parameters.xls'),'file') && exist(fullfile(Field,'ROI.txt'),'file')
        set(handles.textSource,'String',Field);
        set(handles.pushbuttonCreate,'Enable','on');
    else
        set(handles.textSource,'String','Picked an invalid source folder');
        set(handles.pushbuttonCreate,'Enable','off');        
    end
end


% --- Executes on button press in pushbuttonCreate.
function pushbuttonCreate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ProjectName = get(handles.editProject,'String');
destDir = fullfile(handles.defaultPath,ProjectName);
sourceDir = get(handles.textSource,'String');

if isequal(exist(destDir,'dir'),7)
    message='A current project exists under this name. All previous work will be lost. Would you like to continue?';
    user_response=GIAqModal('Title','Confirm Create','String',message);
    if user_response
        rmdir(destDir,'s');
        M=CreateProject(destDir,sourceDir);
        handles.output=destDir;
        handles.flag=1;
        guidata(hObject, handles);
        close
    end
else
    M=CreateProject(destDir,sourceDir);
    handles.output=destDir;
    handles.flag=1;
    guidata(hObject, handles);
    close
end

% --- Executes on button press in pushbuttonCancel.
function pushbuttonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

uiresume



function editProject_Callback(hObject, eventdata, handles)
% hObject    handle to editProject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editProject as text
%        str2double(get(hObject,'String')) returns contents of editProject as a double
