function varargout = GIAparameters(varargin)
% GIAPARAMETERS M-file for GIAparameters.fig
%      GIAPARAMETERS, by itself, creates a new GIAPARAMETERS or raises the existing
%      singleton*.
%
%      H = GIAPARAMETERS returns the handle to a new GIAPARAMETERS or the handle to
%      the existing singleton*.
%
%      GIAPARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIAPARAMETERS.M with the given input arguments.
%
%      GIAPARAMETERS('Property','Value',...) creates a new GIAPARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GIAparameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GIAparameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GIAparameters

% Last Modified by GUIDE v2.5 21-May-2010 09:24:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIAparameters_OpeningFcn, ...
                   'gui_OutputFcn',  @GIAparameters_OutputFcn, ...
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


% --- Executes just before GIAparameters is made visible.
function GIAparameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIAparameters (see VARARGIN)
if(nargin~=4)
    GIAmessage('title','Warning','message','call GIAparameters with exactly one parameter')
    return;
end
% 
handles.M = varargin{1};


set(handles.STrace,'Columnformat',{'char','numeric'})
set(handles.STrace,'ColumnEditable',[true true])
set(handles.SProcess,'Columnformat',{'numeric','char'})
set(handles.SProcess,'ColumnEditable',[true false])
set(handles.SOdor,'Columnformat',{'char','char','char','char','char'})
set(handles.SOdor,'ColumnEditable',[true true true true true])
set(handles.SConc,'Columnformat',{'numeric'})
set(handles.SConc,'ColumnEditable',true)
set(handles.SEvent,'Columnformat',{'numeric','numeric','numeric','numeric','numeric','numeric','numeric',{'good','bad'},{'none','core'}})
set(handles.SEvent,'ColumnEditable',[true true true true true true true true true])
set(handles.SZone,'Columnformat',{'char','numeric','numeric'})
set(handles.SZone,'ColumnEditable',[true true true])
set(handles.SROI,'Columnformat',{'char'})
set(handles.SROI,'ColumnEditable',[true])
set(handles.SROI,'Data',handles.M.Project.ROI)
set(handles.SExp,'Columnformat',{'char'})
set(handles.SExp,'ColumnEditable',[true])


% Load Odor Sheet
LoadSheets(handles)

% Choose default command line output for GIAparameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GIAparameters wait for user response (see UIRESUME)

uiwait


% --- Outputs from this function are returned to the command line.
function varargout = GIAparameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.M;
delete(hObject)


function LoadSheets(handles)
Trace=handles.M.Experiment.Trace.Name;
Trace(:,2)= mat2cell(handles.M.Experiment.Trace.Flow,zeros(handles.M.Data.T,1)+1,[1]);
set(handles.STrace,'Data',Trace)

Odor=handles.M.Experiment.Odor.Name;
Odor(:,2)=handles.M.Experiment.Odor.Group;
Odor(:,3)=handles.M.Experiment.Odor.Abr;
Odor(:,4)=handles.M.Experiment.Odor.Label;
Odor(:,5)=handles.M.Experiment.Odor.CasNumber;

set(handles.SOdor,'Data',Odor)

Conc=mat2cell(handles.M.Experiment.Conc.Vial,zeros(handles.M.Data.C,1)+1,[1]);
set(handles.SConc,'Data',Conc)

Event=mat2cell(handles.M.Experiment.Event.Log,zeros(handles.M.Data.E,1)+1,zeros(1,7)+1);
Event(:,8:9)=handles.M.Experiment.Event.Condition;
set(handles.SEvent,'Data',Event)

Zone=handles.M.Experiment.Zone.Name;
Zone(:,2:3)=mat2cell(handles.M.Experiment.Zone.Duration(1:handles.M.Data.Z,1:2),zeros(handles.M.Data.Z,1)+1,[1 1]);
set(handles.SZone,'Data',Zone)

if size(handles.M.Process.D,2)>1
    handles.M.Process.D = handles.M.Process.D';
end
Process=mat2cell(handles.M.Process.D,ones(20,1),1);
Process(1:2,2)={'Smoothing'};
Process(3:5,2)={'Baseline'};
Process(18:20,2)={'Baseline'};
Process(6,2)={'Fitting'};
Process(7:10,2)={'Peak finder'};
Process(11:14,2)={'Valley finder'};
Process(15:17,2)={'User feedback'};
set(handles.SProcess,'Data',Process)

set(handles.SExp,'Data',handles.M.Project.Info(1:5,2))

function [handles] = GetSheets(handles)

Trace=get(handles.STrace,'Data');
Odor=get(handles.SOdor,'Data');
Conc=get(handles.SConc,'Data');
Event=get(handles.SEvent,'Data');
Zone=get(handles.SZone,'Data');
Process=get(handles.SProcess,'Data');
ROI=get(handles.SROI,'Data');
Exp=get(handles.SExp,'Data');

% Traces
handles.M.Experiment.Trace.Name=Trace(:,1);
handles.M.Experiment.Trace.Flow=cell2mat(Trace(:,2));

% Odors
handles.M.Experiment.Odor.Name=Odor(:,1);
handles.M.Experiment.Odor.Group=Odor(:,2);
handles.M.Experiment.Odor.Abr=Odor(:,3);
handles.M.Experiment.Odor.Label=Odor(:,4);
handles.M.Experiment.Odor.CasNumber=Odor(:,5);

% Concentrations
handles.M.Experiment.Conc.Vial=cell2mat(Conc);

% Events
handles.M.Experiment.Event.Log=cell2mat(Event(:,1:7));
handles.M.Experiment.Event.Condition=Event(:,8:9);

% Zones
handles.M.Experiment.Zone.Name=Zone(:,1);
handles.M.Experiment.Zone.Duration(1:handles.M.Data.Z,1:2)=cell2mat(Zone(:,2:3));

handles.M.Process.D=cell2mat(Process(:,1));
handles.M.Project.ROI=ROI;
handles.M.Project.Info(1:5,2)=Exp;

function SaveSheets(handles)

Project=handles.M.Project;
Experiment=handles.M.Experiment;
Process=handles.M.Process;
Data=handles.M.Data;   
save(fullfile(handles.M.Project.Folder,'Project.mat'),'Project','Experiment','Process','Data');
disp('Project.mat saved!');

% --- Executes on button press in pushbuttonLoadRaw.
function pushbuttonLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoadRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

LoadSheets(handles)

% --- Executes on button press in pushbuttonLoadRaw.
function pushbuttonLoadRaw_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoadRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName,FilterIndex] = uigetfile();
if isequal(FilterIndex,0)
else
    [Project Experiment Process N]=ParameterRead(strcat(PathName,FileName));  
    Project.Folder=handles.M.Project.Folder;
    handles.M.Project=Project;
    handles.M.Experiment=Experiment;
    % correct Process (both D and S) to contain 17 parameters
    if length(Process.D)==10
        [newD,newS] = convertProcessDS(Process.D,Process.S);
        Process.D = newD;
        Process.S = newS;
    end    
    handles.M.Process=Process;
    LoadSheets(handles);
end


% --- Executes on button press in pushbuttonSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=GetSheets(handles);
SaveSheets(handles)
guidata(hObject, handles);

% --- Executes on button press in pushbuttonClose.
function pushbuttonClose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume
