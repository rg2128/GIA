
function varargout = GIAreview(varargin)
% GIAREVIEW M-file for GIAreview.fig
%      GIAREVIEW, by itself, creates a new GIAREVIEW or raises the existing
%      singleton*.
%
%      H = GIAREVIEW returns the handle to a new GIAREVIEW or the handle to
%      the existing singleton*.
%
%      GIAREVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIAREVIEW.M with the given input arguments.
%
%      GIAREVIEW('Property','Value',...) creates a new GIAREVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GIAreview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GIAreview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help GIAreview
% Last Modified by GUIDE v2.5 21-Jun-2010 17:03:12
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
% disp('GIAreview.m called with the following parameters!');
% for i=1:nargin
%     if isempty(varargin{i})
%         disp('empty');
%     else
%         disp(varargin{i});
%     end
% end
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIAreview_OpeningFcn, ...
                   'gui_OutputFcn',  @GIAreview_OutputFcn, ...
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
end

% --- Executes just before GIAreview is made visible.
function GIAreview_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIAreview (see VARARGIN)
% need exactly 1 parameter passed in varargin
if(nargin~=4)
    GIAmessage('title','Warning','message','call GIAreview with exactly one parameter')
    return;
end
% 
handles.M = varargin{1};
handles.Nav = [1 1 1 handles.M.Data.T handles.M.Data.G handles.M.Data.Z];
handles = LoadParam(handles);
SetFields(handles);
% Choose default command line output for GIA
handles.output = handles.M;
% Update handles structure
handles = ComputeAndPlot(handles);
guidata(hObject, handles);
% if no waiting, then no dialog, since the program just finishs and outputs
uiwait;
end

% --- Outputs from this function are returned to the command line.
function varargout = GIAreview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.M;
delete(hObject)
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;
end


% --- Executes on button press in NTraceD.
function NTraceD_Callback(hObject, eventdata, handles)
% hObject    handle to NTraceD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Nav(1)==1
    return;
end
if get(handles.AutoSave,'Value')
    handles=SaveParam(handles);
end
handles.Nav(1)=handles.Nav(1)-1;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject, handles);
end

% --- Executes on button press in NTraceU.
function NTraceU_Callback(hObject, eventdata, handles)
% hObject    handle to NTraceU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Nav(1)==handles.Nav(4)
    return;
end
if get(handles.AutoSave,'Value')
    handles=SaveParam(handles);
end
handles.Nav(1)=handles.Nav(1)+1;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject, handles);
end

% --- Executes on button press in NGlomD.
function NGlomD_Callback(hObject, eventdata, handles)
% hObject    handle to NGlomD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Nav(2)==1
    return;
end
if get(handles.AutoSave,'Value')
    handles=SaveParam(handles);
end
handles.Nav(2)=handles.Nav(2)-1;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject, handles);
end

% --- Executes on button press in NGlomU.
function NGlomU_Callback(hObject, eventdata, handles)
% hObject    handle to NGlomU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Nav(2)==handles.Nav(5)
    return;
end
if get(handles.AutoSave,'Value')
    handles=SaveParam(handles);
end
handles.Nav(2)=handles.Nav(2)+1;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject, handles);
end

% --- Executes on button press in NZoneD.
function NZoneD_Callback(hObject, eventdata, handles)
% hObject    handle to NZoneD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Nav(3)==1
    return;
end
if get(handles.AutoSave,'Value')
    handles=SaveParam(handles);
end
handles.Nav(3)=handles.Nav(3)-1;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject, handles);
end

% --- Executes on button press in NZoneU.
function NZoneU_Callback(hObject, eventdata, handles)
% hObject    handle to NZoneU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Nav(3)==handles.Nav(6)
    return;
end
if get(handles.AutoSave,'Value')
    handles=SaveParam(handles);
end
handles.Nav(3)=handles.Nav(3)+1;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject, handles);
end

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'uparrow'
        NTraceU_Callback(hObject, eventdata, handles)
    case 'downarrow'
        NTraceD_Callback(hObject, eventdata, handles)
    case 'rightarrow'
        NGlomU_Callback(hObject, eventdata, handles)
    case 'leftarrow'
        NGlomD_Callback(hObject, eventdata, handles)
    case 'pageup'
        NZoneU_Callback(hObject, eventdata, handles)
    case 'pagedown'
        NZoneD_Callback(hObject, eventdata, handles)
    otherwise
end
end

function TPosition_Callback(hObject, eventdata, handles)
% hObject    handle to TPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp0 = str2double(get(hObject,'String'));
tmp = tmp0;
if tmp > handles.Nav(4)
    tmp = handles.Nav(4);
end
if tmp < 1
    tmp = 1;
end
if tmp ~= round(tmp)
    tmp = round(tmp);
end
if tmp~=tmp0
    set(hObject,'String',num2str(tmp));
end
handles.Nav(1) = tmp;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function GPosition_Callback(hObject, eventdata, handles)
% hObject    handle to GPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp0 = str2double(get(hObject,'String'));
tmp = tmp0;
if tmp > handles.Nav(5)
    tmp = handles.Nav(5);
end
if tmp < 1
    tmp = 1;
end
if tmp ~= round(tmp)
    tmp = round(tmp);
end
if tmp~=tmp0
    set(hObject,'String',num2str(tmp));
end
handles.Nav(2) = tmp;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function ZPosition_Callback(hObject, eventdata, handles)
% hObject    handle to ZPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp0 = str2double(get(hObject,'String'));
tmp = tmp0;
if tmp > handles.Nav(6)
    tmp = handles.Nav(6);
end
if tmp < 1
    tmp = 1;
end
if tmp ~= round(tmp)
    tmp = round(tmp);
end
if tmp~=tmp0
    set(hObject,'String',num2str(tmp));
end
handles.Nav(3) = tmp;
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end


% --- Executes on button press in pushbuttonDefault.
function pushbuttonDefault_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = LoadDefaultParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

% --- Executes on button press in pushbuttonLoad.
function pushbuttonLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

% --- Executes on button press in pushbuttonSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = SaveParam(handles);
guidata(hObject,handles);
end

function handles = SaveParam(handles)
%% helper function: saving handles.actPar into Project.mat
%  changed in both memory and disk
%  one cell in handles.M.Experiment.Event.Condition
%  one column in handles.M.Process.S(g,:,t)
%  called by pushbuttonSave_Callback and when autosave available
t=handles.Nav(1);
g=handles.Nav(2);
z=handles.Nav(3);
% saving current active parameters
handles.M.Process.S(g,:,t)=handles.actPar(:); 
% saving record quality from user judgement. double saved
tmpLog = handles.M.Experiment.Event.Log;
if handles.actPar(15)
    handles.M.Experiment.Event.Condition{tmpLog(:,1)==t & tmpLog(:,2)==z,1} = 'good';
else
    handles.M.Experiment.Event.Condition{tmpLog(:,1)==t & tmpLog(:,2)==z,1} = 'bad';
end
% save in disk and return
Project=handles.M.Project;
Experiment=handles.M.Experiment;
Process=handles.M.Process;
Data=handles.M.Data;   
save(fullfile(Project.Folder,'Project.mat'),'Project','Experiment','Process','Data');
display(sprintf('Project Saved in %s',Project.Folder));
return;
end

function handles = LoadDefaultParam(handles)
%  savePar is a very strangly defined vector saving current parameters
%  it uses 1 3 7 10 to indicate whether to use default parameters for 
%  signal sign(not used), smoothing, BaseLine, peak finder
%  if an indicator is 1, it uses the following savePar
%  if 0, it uses the defPar
handles.actPar = handles.M.Process.D';
if handles.actPar(6)==0 || handles.actPar(6)==4 %% to handle historic data since the fit option used to be a check box
    handles.actPar(6)=1;
    handles.M.Process.D(6)=1;
end
end

function handles = LoadParam(handles)
%  savePar is a very strangly defined vector saving current parameters
%  it uses 1 3 7 10 to indicate whether to use default parameters for 
%  signal sign(not used), smoothing, BaseLine, peak finder
%  if an indicator is 1, it uses the following savePar
%  if 0, it uses the defPar
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
handles.actPar = handles.M.Process.S(g,:,t);
if handles.actPar(6)==0 || handles.actPar(6)==4 %% to handle historic data since the fit option used to be a check box
    handles.actPar(6)=1;
end
end

function SetFields(handles)
%%  set up various displays, specific to g/t
%   there is no GetFields since each component has its Callback
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);

SetOneParam(handles.SmoothSize,'On',handles.actPar(1),handles.M.Process.D(1));
SetOneParam(handles.SmoothMethod,'On',handles.actPar(2),handles.M.Process.D(2));
SetOneParam(handles.BaseWindowSize,'On',handles.actPar(3),handles.M.Process.D(3));
SetOneParam(handles.BaseStepSize,'On',handles.actPar(4),handles.M.Process.D(4));
SetOneParam(handles.BaseZeroEnd,'On',handles.actPar(5),handles.M.Process.D(5));
SetOneParam(handles.SignalFit,'On',handles.actPar(6),handles.M.Process.D(6));
SetOneParam(handles.PeakFinder1,'On',handles.actPar(7),handles.M.Process.D(7));
SetOneParam(handles.PeakFinder2,'On',handles.actPar(8),handles.M.Process.D(8));
SetOneParam(handles.PeakFinder3,'On',handles.actPar(9),handles.M.Process.D(9));
SetOneParam(handles.PeakFinder4,'On',handles.actPar(10),handles.M.Process.D(10));
SetOneParam(handles.PeakFinder5,'On',handles.actPar(11),handles.M.Process.D(11));
SetOneParam(handles.PeakFinder6,'On',handles.actPar(12),handles.M.Process.D(12));
SetOneParam(handles.PeakFinder7,'On',handles.actPar(13),handles.M.Process.D(13));
SetOneParam(handles.PeakFinder8,'On',handles.actPar(14),handles.M.Process.D(14));
SetOneParam(handles.RecordQuality,'On',handles.actPar(15),handles.M.Process.D(15));
% 
if handles.actPar(18)==1
    SetOneParam(handles.BaseWindowSize,'On',handles.actPar(3),handles.M.Process.D(3));
    SetOneParam(handles.BaseStepSize,'On',handles.actPar(4),handles.M.Process.D(4));    
    SetOneParam(handles.BaseZeroEnd,'On',handles.actPar(5),handles.M.Process.D(5));        
    set(handles.BaseInit,'Enable','Off');
    set(handles.BaseFactor,'Enable','Off');    
else
    set(handles.BaseWindowSize,'Enable','Off');
    set(handles.BaseStepSize,'Enable','Off');    
    set(handles.BaseZeroEnd,'Enable','Off');        
    SetOneParam(handles.BaseInit,'On',handles.actPar(19),handles.M.Process.D(19));    
    SetOneParam(handles.BaseFactor,'On',handles.actPar(20),handles.M.Process.D(20));        
end
% display trace quality
if handles.actPar(15)==1
    SetOneParam(handles.NoPeak,'On',handles.actPar(16),handles.M.Process.D(16));
    SetOneParam(handles.NoValley,'On',handles.actPar(17),handles.M.Process.D(17));
else
    set(handles.NoPeak,'Enable','Off');
    set(handles.NoValley,'Enable','Off');    
end

% display auto save option
% this one is speical coz it is not loaded from anywhere
% the user input determines, hence it is not set on each update
% set(handles.AutoSave,'Value',0);

% display navigation status
set(handles.TPosition,'String',num2str(t))
set(handles.GPosition,'String',num2str(g))
set(handles.ZPosition,'String',num2str(z))
set(handles.TCount,'String',strcat('/',num2str(handles.Nav(4))))
set(handles.GCount,'String',strcat('/',num2str(handles.Nav(5))))
set(handles.ZCount,'String',strcat('/',num2str(handles.Nav(6))))

% fit parameters
% call this within ComputeAndPlot()
% handles = SetFitParam(handles);

end

function SetBaseFit(handles)
    set(handles.BaseInit,'String',num2str(handles.Plots.BaseFit(1)));
    set(handles.BaseFactor,'String',num2str(handles.Plots.BaseFit(2)));   
end

function SetFitParam(handles)
if handles.actPar(6)==1
    set(handles.AutoFit,'Enable','Off');
    % lower bound 19-27
%    set(handles.editLowT,'Enable','Off'); 
    set(handles.editLowA,'Enable','Off'); 
    set(handles.editLowB,'Enable','Off'); 
    set(handles.editLowTau0,'Enable','Off');         
    set(handles.editLowC,'Enable','Off'); 
    set(handles.editLowD,'Enable','Off'); 
    set(handles.editLowE,'Enable','Off'); 
    set(handles.editLowTau,'Enable','Off'); 
    set(handles.editLowF,'Enable','Off'); 
    % upper bound 28-36
%    set(handles.editHighT,'Enable','Off');
    set(handles.editHighA,'Enable','Off');
    set(handles.editHighB,'Enable','Off');
    set(handles.editHighTau0,'Enable','Off');     
    set(handles.editHighC,'Enable','Off');
    set(handles.editHighD,'Enable','Off');
    set(handles.editHighE,'Enable','Off');
    set(handles.editHighTau,'Enable','Off');      
    set(handles.editHighF,'Enable','Off');

    % current fit parameters 37-45 [T a b c d e f tau]
%   set(handles.sliderT,'Enable','Off');    
    set(handles.sliderA,'Enable','Off');    
    set(handles.sliderB,'Enable','Off');    
    set(handles.sliderTau0,'Enable','Off');            
    set(handles.sliderC,'Enable','Off');    
    set(handles.sliderD,'Enable','Off');    
    set(handles.sliderE,'Enable','Off');    
    set(handles.sliderTau,'Enable','Off');        
    set(handles.sliderF,'Enable','Off');    

    % also display these current fit parameters
%    set(handles.displayT,'Enable','Off');    
    set(handles.displayA,'Enable','Off');    
    set(handles.displayB,'Enable','Off');
    set(handles.displayTau0,'Enable','Off');                    
    set(handles.displayC,'Enable','Off');    
    set(handles.displayD,'Enable','Off');    
    set(handles.displayE,'Enable','Off');    
    set(handles.displayTau,'Enable','Off');            
    set(handles.displayF,'Enable','Off');    


    return;
end
% alias
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
tFit = handles.M.Process.Fit(t,g,z);
% fitting parameters
SetOneParam(handles.AutoFit,'On',tFit.autofit,tFit.autofit);
% lower bound
%SetOneParam(handles.editLowT,'On',tFit.lb(1),tFit.lb(1));
SetOneParam(handles.editLowA,'On',tFit.lb(1),tFit.lb(1));
SetOneParam(handles.editLowB,'On',tFit.lb(2),tFit.lb(2));
if handles.actPar(6)==2
    set(handles.editLowTau0,'Enable','Off');
else
    SetOneParam(handles.editLowTau0,'On',tFit.lb(3),tFit.lb(3));    
end
SetOneParam(handles.editLowC,'On',tFit.lb(4),tFit.lb(4));
SetOneParam(handles.editLowD,'On',tFit.lb(5),tFit.lb(5));
SetOneParam(handles.editLowE,'On',tFit.lb(6),tFit.lb(6));
SetOneParam(handles.editLowTau,'On',tFit.lb(7),tFit.lb(7));
SetOneParam(handles.editLowF,'On',tFit.lb(8),tFit.lb(8));

% upper bound
%SetOneParam(handles.editHighT,'On',tFit.ub(1),tFit.ub(1));
SetOneParam(handles.editHighA,'On',tFit.ub(1),tFit.ub(1));
SetOneParam(handles.editHighB,'On',tFit.ub(2),tFit.ub(2));
if handles.actPar(6)==2
    set(handles.editHighTau0,'Enable','Off');
else
    SetOneParam(handles.editHighTau0,'On',tFit.ub(3),tFit.ub(3));
end
SetOneParam(handles.editHighC,'On',tFit.ub(4),tFit.ub(4));
SetOneParam(handles.editHighD,'On',tFit.ub(5),tFit.ub(5));
SetOneParam(handles.editHighE,'On',tFit.ub(6),tFit.ub(6));
SetOneParam(handles.editHighTau,'On',tFit.ub(7),tFit.ub(7));
SetOneParam(handles.editHighF,'On',tFit.ub(8),tFit.ub(8));

% also set min max of sliders
%set(handles.sliderT,'Min',tFit.lb(1),'Max',tFit.ub(1));
set(handles.sliderA,'Min',tFit.lb(1),'Max',tFit.ub(1));
set(handles.sliderB,'Min',tFit.lb(2),'Max',tFit.ub(2));
if handles.actPar(6)==2
    set(handles.sliderTau0,'Enable','Off');
else
    set(handles.sliderTau0,'Min',tFit.lb(3),'Max',tFit.ub(3));    
end
set(handles.sliderC,'Min',tFit.lb(4),'Max',tFit.ub(4));
set(handles.sliderD,'Min',tFit.lb(5),'Max',tFit.ub(5));
set(handles.sliderE,'Min',tFit.lb(6),'Max',tFit.ub(6));
set(handles.sliderTau,'Min',tFit.lb(7),'Max',tFit.ub(7));    
set(handles.sliderF,'Min',tFit.lb(8),'Max',tFit.ub(8));


% alias
if tFit.autofit
    actFit = tFit.auto;
else
    actFit = tFit.manual;
end
% current fit parameters 35-42 [T a b c d e f tau]    
%SetOneParam(handles.sliderT,'On',actFit(1),actFit(1));
SetOneParam(handles.sliderA,'On',actFit(1),actFit(1));
SetOneParam(handles.sliderB,'On',actFit(2),actFit(2));
if handles.actPar(6)==2
    set(handles.sliderTau0,'Enable','Off');
else
    SetOneParam(handles.sliderTau0,'On',actFit(3),actFit(3));
end
SetOneParam(handles.sliderC,'On',actFit(4),actFit(4));
SetOneParam(handles.sliderD,'On',actFit(5),actFit(5));
SetOneParam(handles.sliderE,'On',actFit(6),actFit(6));
SetOneParam(handles.sliderTau,'On',actFit(7),actFit(7));
SetOneParam(handles.sliderF,'On',actFit(8),actFit(8));

% also display these current fit parameters
%SetOneParam(handles.displayT,'On',actFit(1),actFit(1));
SetOneParam(handles.displayA,'On',actFit(1),actFit(1));
SetOneParam(handles.displayB,'On',actFit(2),actFit(2));
if handles.actPar(6)==2
    set(handles.displayTau0,'Enable','Off');
else
    SetOneParam(handles.displayTau0,'On',actFit(3),actFit(3));
end
SetOneParam(handles.displayC,'On',actFit(4),actFit(4));
SetOneParam(handles.displayD,'On',actFit(5),actFit(5));
SetOneParam(handles.displayE,'On',actFit(6),actFit(6));
SetOneParam(handles.displayTau,'On',actFit(7),actFit(7));
SetOneParam(handles.displayF,'On',actFit(8),actFit(8));

end

function SetOneParam(h,onoff,v,dv)
% helper function due to set of paramters growing too fast
% elden @ Jun 1
set(h,'Enable',onoff);
style = get(h,'Style');
switch style
    case {'popupmenu','togglebutton','checkbox','slider'}
        set(h,'Value',v);
    case {'edit','text'}
        if v==round(v)
            set(h,'String',num2str(v));
        else
            set(h,'String',num2str(v,'%2.2f'));
        end
    otherwise
        disp('missed one style here')
end
if v==dv
    set(h,'ForegroundColor',[0 0 0]);
else
    set(h,'ForegroundColor',[1 0 0]);
end
end

%% for components

function SmoothSize_Callback(hObject, eventdata, handles)
% hObject    handle to SmoothSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(1) = UpdateEditBox(hObject,handles.M.Process.D(1),1);
guidata(hObject,handles);
handles = ComputeAndPlot(handles);
end

% --- Executes on selection change in SmoothMethod.
function SmoothMethod_Callback(hObject, eventdata, handles)
% hObject    handle to SmoothMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns SmoothMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SmoothMethod
tmp = get(hObject,'Value');
% if different with default, change color; else use black
if tmp == handles.M.Process.D(2)
    set(hObject,'ForegroundColor',[0 0 0]);
else
    set(hObject,'ForegroundColor',[1 0 0]);
end
handles.actPar(2) = tmp;
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function BaseWindowSize_Callback(hObject, eventdata, handles)
% hObject    handle to BaseWindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(3) = UpdateEditBox(hObject,handles.M.Process.D(3),1);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function BaseStepSize_Callback(hObject, eventdata, handles)
% hObject    handle to BaseStepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(4) = UpdateEditBox(hObject,handles.M.Process.D(4),1);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

% --- Executes on button press in BaseZeroEnd.
function BaseZeroEnd_Callback(hObject, eventdata, handles)
% hObject    handle to BaseZeroEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'Value'); 
handles.actPar(5) = tmp;
if tmp == handles.M.Process.D(5)
    set(hObject,'ForegroundColor',[0 0 0]);
else
    set(hObject,'ForegroundColor',[1 0 0]);
end 
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function SignalFit_Callback(hObject, eventdata, handles)
% hObject    handle to SignalFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'Value'); 
handles.actPar(6) = tmp;
if tmp == handles.M.Process.D(6)
    set(hObject,'ForegroundColor',[0 0 0]);
else
    set(hObject,'ForegroundColor',[1 0 0]);
end 
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function PeakFinder1_Callback(hObject, eventdata, handles)
% hObject    handle to PeakFinder1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(7) = UpdateEditBox(hObject,handles.M.Process.D(7),0);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function PeakFinder2_Callback(hObject, eventdata, handles)
% hObject    handle to PeakFinder2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(8) = UpdateEditBox(hObject,handles.M.Process.D(8),0);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function PeakFinder3_Callback(hObject, eventdata, handles)
% hObject    handle to PeakFinder3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(9) = UpdateEditBox(hObject,handles.M.Process.D(9),1);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function PeakFinder4_Callback(hObject, eventdata, handles)
% hObject    handle to PeakFinder4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(10) = UpdateEditBox(hObject,handles.M.Process.D(10),1);
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function PeakFinder5_Callback(hObject, eventdata, handles)
% hObject    handle to PeakFinder5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(11) = UpdateEditBox(hObject,handles.M.Process.D(11),0);    
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function PeakFinder6_Callback(hObject, eventdata, handles)
% hObject    handle to PeakFinder6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(12) = UpdateEditBox(hObject,handles.M.Process.D(12),0);    
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end


function PeakFinder7_Callback(hObject, eventdata, handles)
% hObject    handle to PeakFinder7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(13) = UpdateEditBox(hObject,handles.M.Process.D(13),1);    
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

function PeakFinder8_Callback(hObject, eventdata, handles)
% hObject    handle to PeakFinder8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(14) = UpdateEditBox(hObject,handles.M.Process.D(14),1);    
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

% --- Executes on button press in RecordQuality.
function RecordQuality_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to RecordQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(15) = get(hObject,'Value'); % 1 for 'good' and 0 or 'bad'
if handles.actPar(15)
    set(handles.NoPeak,'Enable','On');
    set(handles.NoValley,'Enable','On');    
else
    set(handles.NoPeak,'Enable','Off');
    set(handles.NoValley,'Enable','Off');    
end
guidata(hObject,handles);
end

% --- Executes on button press in NoPeak.
function NoPeak_Callback(hObject, eventdata, handles)
% hObject    handle to NoPeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.PeakFinder2,'String',num2str(.05))
handles.actPar(16) = get(hObject,'Value'); % 1 for 'good' and 0 or 'bad'
if handles.actPar(16)
    set(handles.PeakFinder2,'string','0.05'); 
    handles.actPar(8) = UpdateEditBox(handles.PeakFinder2,handles.M.Process.D(8),0);
else
    set(handles.PeakFinder2,'string',num2str(handles.M.Process.D(8))); 
    handles.actPar(8) = UpdateEditBox(handles.PeakFinder2,handles.M.Process.D(8),0);    
end
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end

% --- Executes on button press in NoValley.
function NoValley_Callback(hObject, eventdata, handles)
% hObject    handle to NoValley (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(17) = get(hObject,'Value'); % 1 for 'good' and 0 or 'bad'
if handles.actPar(17)
    set(handles.PeakFinder6,'string','0.05'); 
    handles.actPar(12) = UpdateEditBox(handles.PeakFinder6,handles.M.Process.D(12),0);
else
    set(handles.PeakFinder6,'string',num2str(handles.M.Process.D(12))); 
    handles.actPar(12) = UpdateEditBox(handles.PeakFinder6,handles.M.Process.D(12),0);    
end
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end


function tmp = UpdateEditBox(hObject,defaultV,roundup)
tmp = str2double(get(hObject,'String'));
if isnan(tmp) || isinf(tmp) % if not numeric, set to defaultV
    tmp = defaultV;
    set(hObject,'String',num2str(tmp));    
end
if roundup 
    if tmp ~= round(tmp) % if not integer, round up
        tmp = round(tmp);
        set(hObject,'String',num2str(tmp));        
    end
end
% if different with default, change color; else use black
if tmp == defaultV
    set(hObject,'ForegroundColor',[0 0 0]);
else
    set(hObject,'ForegroundColor',[1 0 0]);
end
return;
end

function handles = ComputeAndPlot(handles)
%% this function is to compute and plot descriptive terms for a g/trace/zone
%  handles.Nav(1:3):  t,g,z
%  handles.actPar:  the active parameter set for this t/g
%  handles.M:  raw data and experiment settings
%  we do not save any information (neither computed results nor) here
%  since it is just to show how good a set of parameter is 
%  for extracting descriptive terms of a given g/trace
%  %  it is a bit waste of computing to do the following
%  %  1. change zone; 
%  %  but it makes program easier by not saving anything here. 
% 
%  modified @ Jun 4 2010 to save handles that has everything
%  mainly the Process.Fit updated with automatic fitting params
%  most else are just handles, which need no save
handles = ComputeTrace(handles);
PlotTrace(handles);
end

function handles = ComputeTrace(handles)

ot = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
yRaw = handles.M.Data.Raw(:,g,ot);
actPar = handles.actPar;
if isvector(actPar) % make row vector
    if size(actPar,1)>1
        actPar = actPar';
    end
else
    error('debug: actPar must be vector');
end
Zone = handles.M.Experiment.Zone.Duration;
OdorOnOff = Zone;
tmpLog = handles.M.Experiment.Event.Log;
for i=1:size(Zone,1)
    OdorOnOff(i,1) = tmpLog(tmpLog(:,1)==ot & tmpLog(:,2)==i, 6);
    OdorOnOff(i,2) = tmpLog(tmpLog(:,1)==ot & tmpLog(:,2)==i, 7);
end
fps = cell2mat(handles.M.Project.Info(5,2));% frame per second
oldFits = handles.M.Process.Fit(ot,g,:);


%% compute
[ySmooth, yBase, ySignal, yFit, RisItvl, DecItvl, newFits, BaseFit] ...
    = ProcessTrace(yRaw,actPar,Zone,OdorOnOff,fps,oldFits);

[P, PeakData, PeakTimes,V, ValleyData, ValleyTimes] ...
    = PeakValley(yFit, actPar, Zone, fps, RisItvl, DecItvl);
      
% % to validate my implementation re-produces the same data
% [y yR yS yB P0 PeakData0 PeakTimes0]=ProcessF(yRaw,fps,[1 1 actPar(1:4) actPar(7:10)],Zone);
% if (actPar(5)==0 && actPar(6)==1) % no zero end, fitting none
%     if sum(yFit-y)~=0
%         eorr('debug: new implementation did not re-produce all the same data');
%     end
% end    
    


% toc;

t =1:length(yBase);
%t = t/fps;

%% set fittings
handles.M.Process.Fit(ot,g,:) = newFits;
handles.Plots.yRaw = yRaw;
handles.Plots.ySmooth = ySmooth;
handles.Plots.yBase = yBase;
handles.Plots.ySignal = ySignal;
handles.Plots.yFit = yFit;
handles.Plots.t = t;
handles.Plots.RisItvl = RisItvl;
handles.Plots.DecItvl = DecItvl;
handles.Plots.P = P;
handles.Plots.V = V;
handles.Plots.OdorOnOff = OdorOnOff;
handles.Plots.BaseFit = BaseFit;



end

function handles = ComputeZone(handles)
%% just update fitting data for a zone 
% alias
ot = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
OldFit = handles.M.Process.Fit(ot,g,z);
RisItvl = handles.Plots.RisItvl;
DecItvl = handles.Plots.DecItvl;
xPiece = RisItvl(z,1):DecItvl(z,2);
ySignal = handles.Plots.ySignal;
yFit = handles.Plots.yFit;
actPar = handles.actPar;
Zone = handles.M.Experiment.Zone.Duration;
fps = cell2mat(handles.M.Project.Info(5,2));% frame per second
OdorOnOff = handles.Plots.OdorOnOff;
T = OdorOnOff(1,2)-OdorOnOff(1,1)+1;

% compute
[yFitPiece,NewFit] = ProcessZone(ySignal(xPiece),actPar(6),OldFit,T);    
yFit(xPiece) = yFitPiece;

[P, PeakData, PeakTimes,V, ValleyData, ValleyTimes] ...
    = PeakValley(yFit, actPar, Zone, fps, RisItvl, DecItvl);

% set fittings
handles.M.Process.Fit(ot,g,z) = NewFit;
handles.Plots.yFit = yFit;
handles.Plots.P = P;
handles.Plots.V = V;

end

function PlotTrace(handles)
%% Plot

% set up fitting params
SetBaseFit(handles);
SetFitParam(handles);

% alias
ot = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
newFits = handles.M.Process.Fit(ot,g,:);
yRaw = handles.Plots.yRaw;
ySmooth = handles.Plots.ySmooth;
yBase = handles.Plots.yBase;
ySignal = handles.Plots.ySignal;
yFit = handles.Plots.yFit;
t = handles.Plots.t;
RisItvl = handles.Plots.RisItvl;
DecItvl = handles.Plots.DecItvl;
P = handles.Plots.P;
V = handles.Plots.V;
Zone = handles.M.Experiment.Zone.Duration;
actPar = handles.actPar;
OdorOnOff = handles.Plots.OdorOnOff;
T = OdorOnOff(1,2)-OdorOnOff(1,1)+1;

% clear old axes
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);

% top left
plot(handles.axes1,t,yRaw,'kx',t,ySmooth,'k-',t,yBase,'r-');
set(handles.axes1,'XLim',[min(t) max(t)]);

% bottom
hold(handles.axes2,'on');
plot(handles.axes2,t,ySignal,'k-');
set(handles.axes2,'XLim',[0 max(t)]);
% % plot amplitude threshold
plot(handles.axes2,[min(t) max(t)],[0 0],'c:','LineWidth',2);
plot(handles.axes2,[min(t) max(t)],[actPar(8) actPar(8)],'m:','LineWidth',2);
% % plot fitting
if actPar(6)>1
    for i=1:size(Zone,1)
        switch actPar(6)
            case {2,3}% 4-piece exponential
                xPiece = RisItvl(i,1):DecItvl(i,2);
                yPiece = yFit(xPiece); 
                if newFits(1,1,i).autofit
                    actFit = newFits(1,1,i).auto;
                else
                    actFit = newFits(1,1,i).manual;
                end
                tmpX=1:length(xPiece);
                if actPar(6)==2
                    [yPiecePredict dummy1 dummy2] = Excit2Inhibit(tmpX,T,actFit(1),actFit(2),actFit(4),actFit(5),actFit(6),actFit(7),actFit(8));
                else
                    [yPiecePredict dummy1 dummy2] = Excit2InhibitLS(tmpX,T,actFit(1),actFit(2),actFit(3),actFit(4),actFit(5),actFit(6),actFit(7),actFit(8));                                        
                end
                if newFits(1,1,i).autofit
                    if sum(yPiece==yPiecePredict')~=length(yPiece)
                        error('debug: yPiece~=yPiecePredict?');
                    end
                end
                plot(handles.axes2,t(xPiece),yPiecePredict,'b--','LineWidth',4);                
        end        
    end  % each zone  
end % method
% % plot peak and valley
if ~isempty(P)
    plot(handles.axes2,t(P(:,2)),P(:,3),'x',...
        'MarkerEdgeColor','g','MarkerFaceColor','g',...
        'MarkerSize',10,'LineWidth',2);
end
if ~isempty(V)
    plot(handles.axes2,t(V(:,2)),-V(:,3),'x',...
        'MarkerEdgeColor','r','MarkerFaceColor','r',...
        'MarkerSize',10,'LineWidth',2);        
end


% top right
hold(handles.axes3,'on');
% % the signal
tmpB = Zone(z,1);
tmpE = Zone(z,2);
yPiece = ySignal(tmpB:tmpE);
plot(handles.axes3,t(tmpB:tmpE),yPiece,'k-');
% % zero line
plot(handles.axes3,[min(t) max(t)],[0 0],'c:','LineWidth',2);
plot(handles.axes3,[min(t) max(t)],[actPar(8) actPar(8)],'m:','LineWidth',2);
% % y limit
set(handles.axes3,'XLim',[t(tmpB) t(tmpE)]);
yAxisLim = get(handles.axes3,'YLim');
% % odor on
plot(handles.axes3,[t(OdorOnOff(z,1)) t(OdorOnOff(z,1))],yAxisLim,'y--','LineWidth',2);
text(t(OdorOnOff(z,1)),yAxisLim(2)-0.05*(yAxisLim(2)-yAxisLim(1)),'Odor On');
% % odor off
plot(handles.axes3,[t(OdorOnOff(z,2)) t(OdorOnOff(z,2))],yAxisLim,'y--','LineWidth',2);
text(t(OdorOnOff(z,2)),yAxisLim(1)+0.05*(yAxisLim(2)-yAxisLim(1)),'Odor Off');
% % fitting
if actPar(6)>1
    for i=z:z
        switch actPar(6)
            case {2,3}% 4-piece exponential
                xPiece = RisItvl(i,1):DecItvl(i,2);
                yPiece = yFit(xPiece);                
                if newFits(1,1,i).autofit
                    actFit = newFits(1,1,i).auto;
                else
                    actFit = newFits(1,1,i).manual;
                end
                tmpX=1:length(xPiece);
                if actPar(6)==2
                    [yPiecePredict yExcit yInhib] = Excit2Inhibit(tmpX,T,actFit(1),actFit(2),actFit(4),actFit(5),actFit(6),actFit(7),actFit(8));
                else
                    [yPiecePredict yExcit yInhib] = Excit2InhibitLS(tmpX,T,actFit(1),actFit(2),actFit(3),actFit(4),actFit(5),actFit(6),actFit(7),actFit(8));                                        
                end
                if newFits(1,1,i).autofit
                    if sum(yPiece==yPiecePredict')~=length(yPiece)
                        error('debug: yPiece~=yPiecePredict?');
                    end
                end
                plot(handles.axes3,t(xPiece),yPiecePredict,'b--','LineWidth',4);
                plot(handles.axes3,t(xPiece),yExcit,'g--','LineWidth',2);
                plot(handles.axes3,t(xPiece),yInhib,'r--','LineWidth',2);
        end        
    end  % each zone  
end % method
% % plot peak and valley
if ~isempty(P)
    pInd = find(P(:,2)>=Zone(z,1) & P(:,2)<=Zone(z,2));
    if ~isempty(pInd)
        %% to draw multiple peaks inside a zone
        %  modified by Elden @ 9/29/2011 upon request by qiq
        for i=1:length(pInd)
            plot(handles.axes3,[t(P(pInd(i),2)) t(P(pInd(i),2))],[0 P(pInd(i),3)],'g--','LineWidth',2);
        end
    end
end
if ~isempty(V)
    vInd = find(V(:,2)>=Zone(z,1) & V(:,2)<=Zone(z,2));
    if ~isempty(vInd)
        %% same as peaks
        for i=1:length(vInd)
            plot(handles.axes3,[t(V(vInd(i),2)) t(V(vInd(i),2))],[0 -V(vInd(i),3)],'r--','LineWidth',2);
        end
    end
end
end


% --- Executes on button press in pushbuttonApplyDefault.
function pushbuttonApplyDefault_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonApplyDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message = 'Are you sure? Current default settings will be lost.';
user_response = GIAqModal('title','Warning','string',message);
if ~user_response
    return;
end
% need update both D and 1 particular S column
% so that later the active parameter can be correctly loaded
for i=1:handles.M.Data.G
    for j=1:handles.M.Data.T
        tmpS = handles.M.Process.S(i,:,j);
        if size(handles.M.Process.D,1)>1
            handles.M.Process.D = handles.M.Process.D';
        end
        if sum(tmpS==handles.M.Process.D)==length(handles.actPar)  % same as previous default
            handles.M.Process.S(i,:,j) = handles.actPar; 
        end
    end
end
handles.M.Process.D = handles.actPar;
% update in memory
% handles = LoadParam(handles);
guidata(hObject, handles);
SetFields(handles);
% save into disk
% overwrite Project.mat for the Process varialbe (D+S)
Project=handles.M.Project; 
Experiment=handles.M.Experiment;
Process=handles.M.Process;
Data=handles.M.Data;   
save(fullfile(handles.M.Project.Folder,'Project.mat'),'Project','Experiment','Process','Data');
end

% --- Executes on button press in pushbuttonImport.
function pushbuttonImport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message = 'Current project settings will be overwritten. All previous work will be lost. Would you like to continue?';
user_response=GIAqModal('title','Confirm Settings Import','string',message);
if ~user_response
    return;
end
% we can load any MAT files with a Process variable
[FileName,FilePath]=uigetfile;
T=load(fullfile(FilePath,FileName));
if isempty(T) 
    GIAmessage('title','Warning','message','invalid MAT file to load')    
    return;
end
if ~isfield(T,'Process')
    GIAmessage('title','Warning','message','the file has no Process variable')    
    return;
end 
handles.M.Process=T.Process;
% overwrite Project.mat for the Process varialbe (D+S)
Project=handles.M.Project;
Experiment=handles.M.Experiment;
Process=handles.M.Process;
Data=handles.M.Data;   
save(fullfile(handles.M.Project.Folder,'Project.mat'),'Project','Experiment','Process','Data');
display('Settings imported and saved');
% since all default and current settings changed, we just reload
handles = LoadParam(handles);
SetFields(handles);
handles = ComputeAndPlot(handles);
guidata(hObject, handles);
end

% --- Executes on button press in pushbuttonExport.
function pushbuttonExport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Process=handles.M.Process;
save(fullfile(handles.M.Project.Folder,'Settings.mat'),'Process');
display('Settings exported');
end

% --- Executes on slider movement.
function sliderA_Callback(hObject, eventdata, handles)
% hObject    handle to sliderA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% autofit = 0
handles.M.Process.Fit(t,g,z).autofit = 0;
set(handles.AutoFit,'Value',0);
% manual
tmp = get(hObject,'Value');
handles.M.Process.Fit(t,g,z).manual(1) = tmp;
set(handles.displayA,'string',num2str(tmp));
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end





function editLowA_Callback(hObject, eventdata, handles)
% hObject    handle to editLowA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).lb(1) = tmp;
set(handles.sliderA,'Min',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end



function editHighA_Callback(hObject, eventdata, handles)
% hObject    handle to editHighA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).ub(1) = tmp;
set(handles.sliderA,'Max',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end




% --- Executes on slider movement.
function sliderB_Callback(hObject, eventdata, handles)
% hObject    handle to sliderB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% autofit = 0
handles.M.Process.Fit(t,g,z).autofit = 0;
set(handles.AutoFit,'Value',0);
% manual
tmp = get(hObject,'Value');
handles.M.Process.Fit(t,g,z).manual(2) = tmp;
set(handles.displayB,'string',num2str(tmp));
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end





function editLowB_Callback(hObject, eventdata, handles)
% hObject    handle to editLowB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).lb(2) = tmp;
set(handles.sliderB,'Min',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end





function editHighB_Callback(hObject, eventdata, handles)
% hObject    handle to editHighB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).ub(2) = tmp;
set(handles.sliderB,'Max',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end



% --- Executes on slider movement.
function sliderC_Callback(hObject, eventdata, handles)
% hObject    handle to sliderC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% autofit = 0
handles.M.Process.Fit(t,g,z).autofit = 0;
set(handles.AutoFit,'Value',0);
% manual
tmp = get(hObject,'Value');
handles.M.Process.Fit(t,g,z).manual(4) = tmp;
set(handles.displayC,'string',num2str(tmp));
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end


function editLowC_Callback(hObject, eventdata, handles)
% hObject    handle to editLowC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).lb(4) = tmp;
set(handles.sliderC,'Min',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end


function editHighC_Callback(hObject, eventdata, handles)
% hObject    handle to editHighC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).ub(4) = tmp;
set(handles.sliderC,'Max',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end


% --- Executes on slider movement.
function sliderD_Callback(hObject, eventdata, handles)
% hObject    handle to sliderD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% autofit = 0
handles.M.Process.Fit(t,g,z).autofit = 0;
set(handles.AutoFit,'Value',0);
% manual
tmp = get(hObject,'Value');
handles.M.Process.Fit(t,g,z).manual(5) = tmp;
set(handles.displayD,'string',num2str(tmp));
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end



function editLowD_Callback(hObject, eventdata, handles)
% hObject    handle to editLowD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).lb(5) = tmp;
set(handles.sliderD,'Min',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end





function editHighD_Callback(hObject, eventdata, handles)
% hObject    handle to editHighD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).ub(5) = tmp;
set(handles.sliderD,'Max',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end




% --- Executes on slider movement.
function sliderE_Callback(hObject, eventdata, handles)
% hObject    handle to sliderE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% autofit = 0
handles.M.Process.Fit(t,g,z).autofit = 0;
set(handles.AutoFit,'Value',0);
% manual
tmp = get(hObject,'Value');
handles.M.Process.Fit(t,g,z).manual(6) = tmp;
set(handles.displayE,'string',num2str(tmp));
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end




function editLowE_Callback(hObject, eventdata, handles)
% hObject    handle to editLowE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).lb(6) = tmp;
set(handles.sliderE,'Min',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end





function editHighE_Callback(hObject, eventdata, handles)
% hObject    handle to editHighE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).ub(6) = tmp;
set(handles.sliderE,'Max',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end



% --- Executes on slider movement.
function sliderF_Callback(hObject, eventdata, handles)
% hObject    handle to sliderF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% autofit = 0
handles.M.Process.Fit(t,g,z).autofit = 0;
set(handles.AutoFit,'Value',0);
% manual
tmp = get(hObject,'Value');
handles.M.Process.Fit(t,g,z).manual(8) = tmp;
set(handles.displayF,'string',num2str(tmp));
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end





function editLowF_Callback(hObject, eventdata, handles)
% hObject    handle to editLowF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).lb(8) = tmp;
set(handles.sliderF,'Min',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end





function editHighF_Callback(hObject, eventdata, handles)
% hObject    handle to editHighF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).ub(8) = tmp;
set(handles.sliderF,'Max',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end


% --- Executes on slider movement.
function sliderTau_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% autofit = 0
handles.M.Process.Fit(t,g,z).autofit = 0;
set(handles.AutoFit,'Value',0);
% manual
tmp = get(hObject,'Value');
handles.M.Process.Fit(t,g,z).manual(7) = tmp;
set(handles.displayTau,'string',num2str(tmp));
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end

function editLowTau_Callback(hObject, eventdata, handles)
% hObject    handle to editLowTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).lb(7) = tmp;
set(handles.sliderTau,'Min',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end

function editHighTau_Callback(hObject, eventdata, handles)
% hObject    handle to editHighTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).ub(7) = tmp;
set(handles.sliderTau,'Max',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end


% --- Executes on button press in AutoFit.
function AutoFit_Callback(hObject, eventdata, handles)
% hObject    handle to AutoFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'Value'); 
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
handles.M.Process.Fit(t,g,z).autofit = tmp;
handles = ComputeZone(handles);
% make auto values starting positions of manual tuning
handles.M.Process.Fit(t,g,z).manual = handles.M.Process.Fit(t,g,z).auto;
PlotTrace(handles);
guidata(hObject,handles);
end


% --- Executes on slider movement.
function sliderTau0_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTau0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% autofit = 0
handles.M.Process.Fit(t,g,z).autofit = 0;
set(handles.AutoFit,'Value',0);
% manual
tmp = get(hObject,'Value');
handles.M.Process.Fit(t,g,z).manual(3) = tmp;
set(handles.displayTau0,'string',num2str(tmp));
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end


function editLowTau0_Callback(hObject, eventdata, handles)
% hObject    handle to editLowTau0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).lb(3) = tmp;
set(handles.sliderTau0,'Min',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end


function editHighTau0_Callback(hObject, eventdata, handles)
% hObject    handle to editHighTau0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = handles.Nav(1);
g = handles.Nav(2);
z = handles.Nav(3);
% manual
tmp = str2double(get(hObject,'String'));
handles.M.Process.Fit(t,g,z).ub(3) = tmp;
set(handles.sliderTau0,'Max',tmp);
handles = ComputeZone(handles);
PlotTrace(handles);
guidata(hObject, handles);
end


% --- Executes on selection change in BaseLine.
function BaseLine_Callback(hObject, eventdata, handles)
% hObject    handle to BaseLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(hObject,'Value'); 
handles.actPar(18) = tmp;
if tmp == handles.M.Process.D(18)
    set(hObject,'ForegroundColor',[0 0 0]);
else
    set(hObject,'ForegroundColor',[1 0 0]);
end
if handles.actPar(18)==1
    SetOneParam(handles.BaseWindowSize,'On',handles.actPar(3),handles.M.Process.D(3));
    SetOneParam(handles.BaseStepSize,'On',handles.actPar(4),handles.M.Process.D(4));    
    SetOneParam(handles.BaseZeroEnd,'On',handles.actPar(5),handles.M.Process.D(5));        
    set(handles.BaseInit,'Enable','Off');
    set(handles.BaseFactor,'Enable','Off');    
else
    set(handles.BaseWindowSize,'Enable','Off');
    set(handles.BaseStepSize,'Enable','Off');    
    set(handles.BaseZeroEnd,'Enable','Off');        
    SetOneParam(handles.BaseInit,'On',handles.actPar(19),handles.M.Process.D(19));    
    SetOneParam(handles.BaseFactor,'On',handles.actPar(20),handles.M.Process.D(20));        
end
handles.actPar(19) = -1;
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end



function BaseFactor_Callback(hObject, eventdata, handles)
% hObject    handle to BaseFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(20) = str2double(get(hObject,'String'));
handles.actPar(19) = str2double(get(handles.BaseInit,'String'));
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end


function BaseInit_Callback(hObject, eventdata, handles)
% hObject    handle to BaseInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.actPar(19) = str2double(get(hObject,'String'));
handles.actPar(20) = str2double(get(handles.BaseFactor,'String'));
handles = ComputeAndPlot(handles);
guidata(hObject,handles);
end