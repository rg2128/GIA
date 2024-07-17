function varargout = GIArearrange(varargin)
% GIArearrange is to let user select subset of odors,gloms,conc,etc.
% and also rearrange ROI (gloms) by certain criteria
% It yields rOdor,aOdor,vOdor,rGlom,aGlom,vGlom,aConc,vConc
% the project data is sorted by these vectors
% rOdor is index of sorting odors listed in Parameters.xls by label/structure
% aOdor is binary indicator of user choice of odor names in Parameters.xls
% vOdor is a set of chosen index sorted as in rOdor
% a(r) is the sorted binary indicator
% r(a(r) is the sorted chosen set, a bit difficult to understand at first
% similarly,
% rGlom is resulting index of sorting ROIs listed in ROI.txt by various criteria
% aGlom is the binary choice indicator for unsorted ROIs in ROI.txt
% vGlom = r(a(r)) is the sorted chosen set
% Elden Yu @ 7/21/2010

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GIArearrange_OpeningFcn, ...
                   'gui_OutputFcn',  @GIArearrange_OutputFcn, ...
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


% --- Executes just before GIArearrange is made visible.
function GIArearrange_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GIArearrange (see VARARGIN)
if(nargin~=4)
    GIAmessage('title','Warning','message','call GIArearrange with exactly one parameter')
    return;
end
handles.M = varargin{1};

%% prepare data
if isfield(handles.M.Data,'Sort')
else
  	handles.M.Data.Sort.rOdor(:,1)=1:handles.M.Data.O;
  	handles.M.Data.Sort.rGlom(:,1)=1:handles.M.Data.G;
  	handles.M.Data.Sort.aOdor=true(handles.M.Data.O,1);
    handles.M.Data.Sort.aGlom=true(handles.M.Data.G,1);
  	handles.M.Data.Sort.aConc=true(handles.M.Data.C,1);
    
    Project=handles.M.Project;
    Experiment=handles.M.Experiment;
    Process=handles.M.Process;
    Data=handles.M.Data;
    save(fullfile(handles.M.Project.Folder,'Project.mat'),'Project','Experiment','Process','Data');
    display('Project Saved')
end

%% ploting QM
set(handles.SOdor,'Columnformat',{'char',[],'numeric'})
set(handles.SOdor,'ColumnEditable',[false true false])

Conc=mat2cell(handles.M.Experiment.Conc.Vial,ones(handles.M.Data.C,1),1);
Conc(:,2)=mat2cell(handles.M.Data.Sort.aConc,ones(handles.M.Data.C,1),1);
set(handles.SConc,'Columnformat',{'char',[]})
set(handles.SConc,'ColumnEditable',[false true])
set(handles.SConc,'Data',Conc)

set(handles.CBOdorA,'Value',1);
%%
for i=1:length(handles.M.Experiment.Odor.Label)
    if isnan(handles.M.Experiment.Odor.Label{i})
        handles.M.Experiment.Odor.Label{i} = 'none';
    end
end
%%
[dummy handles.M.Data.Sort.rOdor]=sort(handles.M.Experiment.Odor.Label);
handles.M.Data.Sort.vOdor = handles.M.Data.Sort.rOdor(handles.M.Data.Sort.aOdor(handles.M.Data.Sort.rOdor));

% ploting odor/conc. choice in quality matrix
DrawQM(handles);
UpdateOdorTable(handles);

%% ploting rearranged ROI with default options
List=strvcat('APML','A >> P','A << P','M >> L','M << L','None');
set(handles.MGlomA,'String',List)
set(handles.MGlomA,'Value',1)

[handles.M.Data.Sort.ROIapml,handles.M.Data.Sort.rGlom] = RearrangeROI(handles.M,1);
handles.M.Data.Sort.vGlom = handles.M.Data.Sort.rGlom(handles.M.Data.Sort.aGlom(handles.M.Data.Sort.rGlom));
set(handles.SGlom,'Columnformat',{[],'numeric'});
set(handles.SGlom,'ColumnEditable',[true false]);
% update display
UpdateGlomTable(handles);
DrawROI(handles);

%% Choose default command line output for GIArearrange
handles.output = handles.M;
guidata(hObject, handles);
uiwait

% --- Outputs from this function are returned to the command line.
function varargout = GIArearrange_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.M;
delete(hObject);

function pushbuttonRearrange_Callback(hObject, eventdata, handles)

% Sort Project Data
handles.M=SortProject(handles.M);

% Remove Analysis Data
if isfield(handles.M.Data,'Analysis')
    handles.M.Data=rmfield(handles.M.Data,'Analysis');
end

% save in disk
Project=handles.M.Project;
Experiment=handles.M.Experiment;
Process=handles.M.Process;
Data=handles.M.Data;   
save(fullfile(handles.M.Project.Folder,'Project.mat'),'Project','Experiment','Process','Data');
% save in memory
guidata(hObject,handles);

display('Current project rearranged and saved')

% --- Executes on button press in pushbuttonClose.
function pushbuttonClose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume

function DrawROI(handles)
%% draw ROI in bottom left axis
vGlom = handles.M.Data.Sort.vGlom;
G = length(vGlom);              
ROI = handles.M.Data.Sort.ROIapml;  
cla(handles.axes2);
for i=1:G    
    scatter(ROI(vGlom(i),1),ROI(vGlom(i),2),200,'ob'); hold on
%    text(ROI(vGlom(i),1),ROI(vGlom(i),2),[num2str(vGlom(i)) '/' num2str(i)]);
    text(ROI(vGlom(i),1),ROI(vGlom(i),2),num2str(i));    
end
axis ij;
axis([0 handles.M.Project.ROI{3} 0 handles.M.Project.ROI{4}]);


function DrawQM(handles)
%% draw quality matrix to show odor/conc. choices and good/bad quality
% in gray colormap, default zeros is shown as black for bad records
QM=zeros(handles.M.Data.C,handles.M.Data.O);
% ones are shown as white for good records
for i=1:handles.M.Data.E
    o=handles.M.Experiment.Event.Log(i,3);
    c=handles.M.Experiment.Event.Log(i,4);
    if isequal(handles.M.Experiment.Event.Condition(i,1),{'good'})
        QM(c,o)=1;
    end
end
% 0.5 shown as gray for used odor/conc. so uses can togger choice on off
% to find out the good/bad quality to decide whether it should be chosen
coChoice = double(handles.M.Data.Sort.aConc) * double(handles.M.Data.Sort.aOdor');
QM(coChoice==1) = 0.5;
% display QM
colormap(handles.axes1,gray);
imagesc(QM,'Parent',handles.axes1,[0 1]);
set(get(handles.axes1,'YLabel'),'String','Concentration #')
set(get(handles.axes1,'XLabel'),'String','Odorant #')

% --- Executes when entered data in editable cell(s) in SConc.
function SConc_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to SConc (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
Conc=get(handles.SConc,'Data');
handles.M.Data.Sort.aConc=cell2mat(Conc(:,2));
C=transpose(1:handles.M.Data.C);
handles.M.Data.Sort.vConc=C(handles.M.Data.Sort.aConc);
guidata(hObject,handles);
% update display
DrawQM(handles);

%% next is for updating the odor table and top left axis

% --- Executes when entered data in editable cell(s) in SOdor.
function SOdor_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to SOdor (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
Odor=get(handles.SOdor,'Data');
handles.M.Data.Sort.aOdor=cell2mat(Odor(:,2));
handles.M.Data.Sort.vOdor=handles.M.Data.Sort.rOdor(handles.M.Data.Sort.aOdor(handles.M.Data.Sort.rOdor));
guidata(hObject,handles);
% update display
UpdateOdorTable(handles);
DrawQM(handles);

% --- Executes when selected object is changed in OdorOpt.
function OdorOpt_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in OdorOpt 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
rbLabel = get(hObject,'String');
switch rbLabel
    case 'All' 
        handles.M.Data.Sort.aOdor = true(handles.M.Data.O,1);
    case 'None'
        handles.M.Data.Sort.aOdor = false(handles.M.Data.O,1);
end
handles.M.Data.Sort.vOdor=handles.M.Data.Sort.rOdor(handles.M.Data.Sort.aOdor(handles.M.Data.Sort.rOdor));
guidata(hObject,handles);
% update display
UpdateOdorTable(handles);
DrawQM(handles);

% --- Executes on button press in CBOdorA.
function CBOdorA_Callback(hObject, eventdata, handles)
% hObject    handle to CBOdorA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    [n handles.M.Data.Sort.rOdor]=sort(handles.M.Experiment.Odor.Label);
else
    handles.M.Data.Sort.rOdor(:,1)=1:handles.M.Data.O;
end
handles.M.Data.Sort.vOdor=handles.M.Data.Sort.rOdor(handles.M.Data.Sort.aOdor(handles.M.Data.Sort.rOdor));
guidata(hObject,handles);
% update display
UpdateOdorTable(handles);

function UpdateOdorTable(handles)
Odor = handles.M.Experiment.Odor.Name;
Odor(:,2) = num2cell(handles.M.Data.Sort.aOdor);
[dummy Location] = ismember(1:handles.M.Data.O,handles.M.Data.Sort.vOdor);
Odor(:,3) = num2cell(Location');
set(handles.SOdor,'Data',Odor);

%% next is for updating the glom table and bottom left axis

% --- Executes when entered data in editable cell(s) in SGlom.
function SGlom_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to SGlom (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
Glom=get(handles.SGlom,'Data');
handles.M.Data.Sort.aGlom=cell2mat(Glom(:,1));
handles.M.Data.Sort.vGlom=handles.M.Data.Sort.rGlom(handles.M.Data.Sort.aGlom(handles.M.Data.Sort.rGlom));
guidata(hObject,handles);
% update display
UpdateGlomTable(handles);
DrawROI(handles);        

% --- Executes when selected object is changed in GlomOpt.
function GlomOpt_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in GlomOpt 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
rbLabel = get(hObject,'String');
switch rbLabel
    case 'All' 
        handles.M.Data.Sort.aGlom = true(handles.M.Data.G,1);
    case 'None'
        handles.M.Data.Sort.aGlom = false(handles.M.Data.G,1);
end
handles.M.Data.Sort.vGlom=handles.M.Data.Sort.rGlom(handles.M.Data.Sort.aGlom(handles.M.Data.Sort.rGlom));
guidata(hObject,handles);
% update display
UpdateGlomTable(handles);
DrawROI(handles);        

% --- Executes on selection change in MGlomA.
function MGlomA_Callback(hObject, eventdata, handles)
% hObject    handle to MGlomA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val= get(handles.MGlomA,'Value');
[handles.M.Data.Sort.ROIapml,handles.M.Data.Sort.rGlom] = RearrangeROI(handles.M,val);
handles.M.Data.Sort.vGlom=handles.M.Data.Sort.rGlom(handles.M.Data.Sort.aGlom(handles.M.Data.Sort.rGlom));
guidata(hObject,handles);
% update display
UpdateGlomTable(handles);
DrawROI(handles);

function UpdateGlomTable(handles)
Glom = num2cell(handles.M.Data.Sort.aGlom);
[dummy Location] = ismember(1:handles.M.Data.G,handles.M.Data.Sort.vGlom);
Glom(:,2) = num2cell(Location');
set(handles.SGlom,'Data',Glom);