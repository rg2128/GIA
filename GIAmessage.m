function varargout = GIAmessage(varargin)
% GIAMESSAGE M-file for GIAmessage.fig
%      GIAMESSAGE, by itself, creates a new GIAMESSAGE or raises the existing
%      singleton*.
%
%      H = GIAMESSAGE returns the handle to a new GIAMESSAGE or the handle to
%      the existing singleton*.
%
%      GIAMESSAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIAMESSAGE.M with the given input arguments.
%
%      GIAMESSAGE('Property','Value',...) creates a new GIAMESSAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GIAmessage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GIAmessage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GIAmessage

% Last Modified by GUIDE v2.5 23-Jun-2009 09:14:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIAmessage_OpeningFcn, ...
                   'gui_OutputFcn',  @GIAmessage_OutputFcn, ...
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


% --- Executes just before GIAmessage is made visible.
function GIAmessage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIAmessage (see VARARGIN)

% Choose default command line output for GIAmessage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
if(nargin > 3)
    for index = 1:2:(nargin-3),
        switch lower(varargin{index})
        case 'title'
            set(hObject, 'Name', varargin{index+1});
        case 'message'
            set(handles.textmessage,'String', varargin{index+1});
        otherwise
            error('Invalid input arguments');
        end
    end
end

% UIWAIT makes GIAmessage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GIAmessage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonok.
function pushbuttonok_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close
