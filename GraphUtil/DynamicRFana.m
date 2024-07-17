function varargout = DynamicRFana(varargin)
% DYNAMICRFANA M-file for DynamicRFana.fig
%      DYNAMICRFANA, by itself, creates a new DYNAMICRFANA or raises the existing
%      singleton*.
%
%      H = DYNAMICRFANA returns the handle to a new DYNAMICRFANA or the handle to
%      the existing singleton*.
%
%      DYNAMICRFANA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DYNAMICRFANA.M with the given input arguments.
%
%      DYNAMICRFANA('Property','Value',...) creates a new DYNAMICRFANA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DynamicRFana_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DynamicRFana_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DynamicRFana

% Last Modified by GUIDE v2.5 26-Aug-2009 12:12:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DynamicRFana_OpeningFcn, ...
                   'gui_OutputFcn',  @DynamicRFana_OutputFcn, ...
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

% --- Executes just before DynamicRFana is made visible.
function DynamicRFana_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DynamicRFana (see VARARGIN)


% Choose default command line output for DynamicRFana
handles.StartFrame=15;
handles.EndFrame=60;
handles.Finterval=1;
handles.CurrentFrame=15;
handles.InterpN=3;
handles.OGN=1;
handles.OGswitch=1;
set(handles.GlomN,'String',num2str(1));
set(handles.OdorN,'String',num2str(1));
set(handles.AZ,'Value',300);set(handles.EL,'Value',20);
set(handles.CurrentFrameN,'String',num2str(handles.CurrentFrame));
set(handles.StartFrameN,'String',num2str(handles.StartFrame));
set(handles.EndFrameN,'String',num2str(handles.EndFrame));
set(handles.Fint,'String',num2str(handles.Finterval));
set(handles.InterpNN,'String',num2str(handles.InterpN));
set(handles.Azimuth,'String',num2str(get(handles.AZ,'Value')));
set(handles.Elevation,'String',num2str(get(handles.EL,'Value')));
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using DynamicRFana.


% UIWAIT makes DynamicRFana wait for user response (see UIRESUME)
% uiwait(handles.Image);


% --- Outputs from this function are returned to the command line.
function varargout = DynamicRFana_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% THis will load the project and creat data structure M and plot-----------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName] = uigetfile('c:\GIA\*.mat');
if ~isequal(FileName, 0)
    M=load(strcat(PathName,FileName));
end
handles.M=M;
set(handles.CurrentProj,'String',M.Project.Folder);
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);




% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(gcf)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.CurrentProj,'String'), '?'],...
                     ['Close ' get(handles.CurrentProj,'String'), '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

%delete(handles.axes1)
clear handles.M
clear handles.axes1;refresh(gcf);
handles.StartFrame=15;
handles.EndFrame=60;
handles.Finterval=1;
handles.CurrentFrame=15;
handles.InterpN=3;
handles.OGN=1;
handles.OGswitch=1;
set(handles.CurrentProj,'String','None')
set(handles.GlomN,'String',num2str(1));
set(handles.OdorN,'String',num2str(1));
set(handles.AZ,'Value',300);set(handles.EL,'Value',20);
set(handles.CurrentFrameN,'String',num2str(handles.CurrentFrame));
set(handles.StartFrameN,'String',num2str(handles.StartFrame));
set(handles.EndFrameN,'String',num2str(handles.EndFrame));
set(handles.Fint,'String',num2str(handles.Finterval));
set(handles.InterpNN,'String',num2str(handles.InterpN));
set(handles.Azimuth,'String',num2str(get(handles.AZ,'Value')));
set(handles.Elevation,'String',num2str(get(handles.EL,'Value')));
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton_RFmovie.
function pushbutton_RFmovie_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RFmovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StartFrame=handles.StartFrame;
EndFrame=handles.EndFrame;
Finterval=handles.Finterval;
Tv=StartFrame:Finterval:EndFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_SaveMovie.
function pushbutton_SaveMovie_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SaveMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PathName = uigetdir('c:\');
switch handles.OGswitch
    case 1
        FileName=strcat('RF',handles.M.Project.Folder,'Glom#',num2str(handles.OGN),'.avi');
    case 0
        FileName=strcat('RF',handles.M.Project.Folder,'Odor#',num2str(handles.OGN),'.avi');
end
figure ('position',[30 30 480 360],'NextPlot','replace')
Tv=handles.StartFrame:handles.Finterval:handles.EndFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
Mov=DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
close;
movie2avi(Mov,strcat(PathName,'\',FileName),'compression','Indeo5')


% --- Executes on slider movement.
function AZ_Callback(hObject, eventdata, handles)
% hObject    handle to AZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
AZ=get(hObject,'Value');
set(handles.Azimuth,'String',num2str(handles.AZ));
Tv=handles.CurrentFrame;
EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function EL_Callback(hObject, eventdata, handles)
% hObject    handle to EL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
EL=get(hObject,'Value');
set(handles.Elevation,'String',num2str(get(handles.EL,'Value')));
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function EL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function InterpNN_Callback(hObject, eventdata, handles)
% hObject    handle to InterpNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InterpNN as text
%        str2double(get(hObject,'String')) returns contents of InterpNN as a double
handles.InterpN=str2double(get(hObject,'String'));
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function InterpNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterpNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_CurrentFrame_Callback(hObject, eventdata, handles)
% hObject    handle to slider_CurrentFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
CurrentFrame=handles.StartFrame+get(hObject,'Value')*(handles.EndFrame-handles.StartFrame);
if CurrentFrame<handles.StartFrame
    CurrentFrame=handles.StartFrame;
end
if CurrentFrame>handles.EndFrame
    CurrentFrame=handles.EndFrame;
end
handles.CurrentFrame=round(CurrentFrame);
set(handles.CurrentFrameN,'String',num2str(handles.CurrentFrame));
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_CurrentFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_CurrentFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function StartFrameN_Callback(hObject, eventdata, handles)
% hObject    handle to StartFrameN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartFrameN as text
%        str2double(get(hObject,'String')) returns contents of StartFrameN as a double
handles.StartFrame=str2double(get(hObject,'String'));
if handles.CurrentFrame<handles.StartFrame
    handles.CurrentFrame=handles.StartFrame;
    set(handles.CurrentFrameN,'String',num2str(handles.CurrentFrame));
end
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function StartFrameN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartFrameN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndFrameN_Callback(hObject, eventdata, handles)
% hObject    handle to EndFrameN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndFrameN as text
%        str2double(get(hObject,'String')) returns contents of EndFrameN as a double
handles.EndFrame=str2double(get(hObject,'String'));
if handles.CurrentFrame>handles.EndFrame
    handles.CurrentFrame=handles.EndFrame;
    set(handles.CurrentFrameN,'String',num2str(handles.CurrentFrame));
end
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function EndFrameN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndFrameN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fint_Callback(hObject, eventdata, handles)
% hObject    handle to Fint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fint as text
%        str2double(get(hObject,'String')) returns contents of Fint as a double
handles.Finterval=str2double(get(hObject,'String'));
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Fint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function CurrentProj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentProj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Azimuth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Azimuth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function CurrentFrameN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentFrameN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on Azimuth and none of its controls.
function Azimuth_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Azimuth (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


function GlomN_Callback(hObject, eventdata, handles)
% hObject    handle to GlomN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GlomN as text
%        str2double(get(hObject,'String')) returns contents of GlomN as a double
GlomN=get(hObject,'String');
set(handles.GlomN,'String',GlomN)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function GlomN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GlomN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function OdorN_Callback(hObject, eventdata, handles)
% hObject    handle to OdorN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OdorN as text
%        str2double(get(hObject,'String')) returns contents of OdorN as a double

OdorN=get(hObject,'String');
set(handles.OdorN,'String',OdorN)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function OdorN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OdorN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_updateGlomN.
function pushbutton_updateGlomN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_updateGlomN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.OGswitch=1;
handles.OGN=str2double(get(handles.GlomN,'String'));
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);
pushbutton_RFmovie_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_UpdateOdorN.
function pushbutton_UpdateOdorN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_UpdateOdorN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.OGswitch=0;
handles.OGN=str2double(get(handles.OdorN,'String'));
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
guidata(hObject, handles);
pushbutton_RFmovie_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function SaveFigure_Callback(hObject, eventdata, handles)
% hObject    handle to SaveFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PathName = uigetdir('c:\');
switch handles.OGswitch
    case 1
        FileName=strcat('RF-',handles.M.Project.Folder,'Glom#',num2str(handles.OGN), ...
            'F',num2str(handles.CurrentFrame),'.jpg');
    case 0
        FileName=strcat('RF-',handles.M.Project.Folder,'Odor#',num2str(handles.OGN), ... 
            cell2mat(handles.M.Experiment.Odor.Name(handles.M.Data.Sort.vOdor(handles.OGN))),'F',num2str(handles.CurrentFrame),'.jpg');
end
figure ('position',[30 30 480 360],'NextPlot','replace')
Tv=handles.CurrentFrame;
AZ=get(handles.AZ,'Value');EL=get(handles.EL,'Value');
DynamicRFmovie(handles.M,handles.OGN,Tv,handles.InterpN,handles.OGswitch,[AZ EL]);
print('-cmyk','-djpeg','-r200','-f1',strcat(PathName,'\',FileName))
close;
% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
