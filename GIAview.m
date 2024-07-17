function varargout = GIAview(varargin)
% GIAVIEW M-file for GIAview.fig
%      GIAVIEW, by itself, creates a new GIAVIEW or raises the existing
%      singleton*.
%
%      H = GIAVIEW returns the handle to a new GIAVIEW or the handle to
%      the existing singleton*.
%
%      GIAVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIAVIEW.M with the given input arguments.
%
%      GIAVIEW('Property','Value',...) creates a new GIAVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GIAview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GIAview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GIAview

% Last Modified by GUIDE v2.5 09-Jul-2009 12:00:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIAview_OpeningFcn, ...
                   'gui_OutputFcn',  @GIAview_OutputFcn, ...
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


% --- Executes just before GIAview is made visible.
function GIAview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIAview (see VARARGIN)

% Import Project Data
if(nargin > 3)
    for index = 1:2:(nargin-3),
        switch lower(varargin{index})
        case 'data'
            handles.M=varargin{index+1};
        otherwise
            error('Invalid input arguments');
        end
    end
end

handles.Nav=[1 handles.M.Data.T];

List='Raw Data';
handles.Temp=handles.M.Data.Raw;
handles.CL(1,:)=[min(min(min(handles.Temp))) max(max(max(handles.Temp)))];
n=1;
if isfield(handles.M.Data,'Process')
    List=strvcat(List,'Processed Data');
    handles.Temp=handles.M.Data.Process.Processed;
    handles.CL(2,:)=[-.05 max(max(max(handles.Temp)))];
    n=2;
end
if isfield(handles.M.Data,'Sort')
    List=strvcat(List,'Sorted Data');
    handles.Temp=handles.M.Data.Sort.Sorted;
    handles.Nav(2)=sum(handles.M.Data.Sort.aOdor);
    handles.CL(3,:)=[-.05 max(max(max(handles.Temp)))];
    n=3;
end

set(handles.PMenu,'String',List)
set(handles.PMenu,'Value',n)
set(handles.TCount,'String',strcat('/',num2str(handles.Nav(2))))

GeneratePlots(handles);

% Choose default command line output for GIAview
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GIAview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GIAview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonGoTo.
function pushbuttonGoTo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonGoTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t=round(str2num(get(handles.TPosition,'String')));

if t>0 && t<handles.Nav(2)+1
   	handles.Nav(1)=t;
	GeneratePlots(handles);
    guidata(hObject, handles);
end


function TPosition_Callback(hObject, eventdata, handles)
% hObject    handle to TPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TPosition as text
%        str2double(get(hObject,'String')) returns contents of TPosition as a double


% --- Executes during object creation, after setting all properties.
function TPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NTraceD.
function NTraceD_Callback(hObject, eventdata, handles)
% hObject    handle to NTraceD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(handles.Nav(1),1)
else
    handles.Nav(1)=handles.Nav(1)-1;
    GeneratePlots(handles);
    guidata(hObject, handles);
end


% --- Executes on button press in NTraceU.
function NTraceU_Callback(hObject, eventdata, handles)
% hObject    handle to NTraceU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(handles.Nav(1),handles.Nav(2))
else
    handles.Nav(1)=handles.Nav(1)+1;
    GeneratePlots(handles);
    guidata(hObject, handles);
end


% --- Executes on selection change in PMenu.
function PMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PMenu

val = get(hObject,'Value');
switch val
case 1
	handles.Temp=handles.M.Data.Raw;
    handles.Nav(2)=handles.M.Data.T;
case 2
	handles.Temp=handles.M.Data.Process.Processed;
    handles.Nav(2)=handles.M.Data.T;
case 3
	handles.Temp=handles.M.Data.Sort.Sorted;
    handles.Nav(1)=1;
    handles.Nav(2)=sum(handles.M.Data.Sort.aOdor);
end

set(handles.TCount,'String',strcat('/',num2str(handles.Nav(2))))
GeneratePlots(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function GeneratePlots(handles)

t=handles.Nav(1);
set(handles.TPosition,'String',num2str(t))
val = get(handles.PMenu,'Value');

imagesc(handles.Temp(:,:,t))
set(handles.axes1,'CLim',handles.CL(val,:))
colorbar
% surf(handles.axes1,A,'edgecolor','none')
% view(2)
% set(handles.axes1,'XLim',[1 max(t)])
