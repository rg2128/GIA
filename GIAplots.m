function varargout = GIAplots(varargin)
% GIAPLOTS M-file for GIAplots.fig
%      GIAPLOTS, by itself, creates a new GIAPLOTS or raises the existing
%      singleton*.
%
%      H = GIAPLOTS returns the handle to a new GIAPLOTS or the handle to
%      the existing singleton*.
%
%      GIAPLOTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIAPLOTS.M with the given input arguments.
%
%      GIAPLOTS('Property','Value',...) creates a new GIAPLOTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GIAplots_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GIAplots_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GIAplots

% Last Modified by GUIDE v2.5 21-Jul-2010 15:15:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIAplots_OpeningFcn, ...
                   'gui_OutputFcn',  @GIAplots_OutputFcn, ...
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


% --- Executes just before GIAplots is made visible.
function GIAplots_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIAplots (see VARARGIN)

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

% Choose default command line output for GIAplots
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GIAplots wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GIAplots_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject)


% --- Executes on button press in pushbuttonPlotTemporal.
function pushbuttonPlotTemporal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotTemporal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PlotTemporalHeatMaps(handles.M)

% --- Executes on button press in pushbuttonPlotIntensity.
function pushbuttonPlotIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PlotPeakIntensityHeatMaps(handles.M)

% --- Executes on button press in pushbuttonPlotTuning.
function pushbuttonPlotTuning_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotTuning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.M.Data,'Analysis')
    PlotTuningHeatMaps(handles.M)
else
    GIAmessage('title','Warning','message','Analyze Project File')
end


% --- Executes on button press in pushbuttonSparseM.
function pushbuttonSparseM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSparseM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.M.Data,'Analysis')
    PlotSparseMatrix(handles.M)
else
    GIAmessage('title','Warning','message','Analyze Project File')
end

% --- Executes on button press in pushbuttonPlotHeatMaps.
function pushbuttonPlotHeatMaps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotHeatMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.M.Data,'Analysis')
    PlotTemporalHeatMaps(handles.M)
    PlotPeakIntensityHeatMaps(handles.M)
    PlotTuningHeatMaps(handles.M)
    PlotSparseMatrix(handles.M)
else
    GIAmessage('title','Warning','message','Analyze Project File')
end


% --- Executes on button press in pushbuttonPlotAllStats.
function pushbuttonPlotAllStats_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotAllStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles.M.Data,'Analysis')
    PlotStats(handles.M)  
else
    GIAmessage('title','Warning','message','Analyze Project File')
end


% --- Executes on button press in PlotAllSpatialandHeatmaps.
function PlotAllSpatialandHeatmaps_Callback(hObject, eventdata, handles)
% hObject    handle to PlotAllSpatialandHeatmaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles.M.Data,'Analysis')
    PlotAllSpatialandHeatmaps(handles.M)  
else
    GIAmessage('title','Warning','message','Analyze Project File')
end
