function varargout = tarquin_visualize(varargin)
% TARQUIN_VISUALIZE MATLAB code for tarquin_visualize.fig
%      Jeff Stout MIT 08/28/2017
%      Use batch_tarquin to generate rdainfo_withdata.mat
%      Initialy this was used to compare TE = 30ms to 135ms data to
%      visualize Lactate, so that explains that button.
%
%      TARQUIN_VISUALIZE, by itself, creates a new TARQUIN_VISUALIZE or raises the existing
%      singleton*.
%
%      H = TARQUIN_VISUALIZE returns the handle to a new TARQUIN_VISUALIZE or the handle to
%      the existing singleton*.
%
%      TARQUIN_VISUALIZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TARQUIN_VISUALIZE.M with the given input arguments.
%
%      TARQUIN_VISUALIZE('Property','Value',...) creates a new TARQUIN_VISUALIZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tarquin_visualize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tarquin_visualize_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tarquin_visualize

% Last Modified by GUIDE v2.5 28-Aug-2017 15:50:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tarquin_visualize_OpeningFcn, ...
                   'gui_OutputFcn',  @tarquin_visualize_OutputFcn, ...
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


% --- Executes just before tarquin_visualize is made visible.
function tarquin_visualize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tarquin_visualize (see VARARGIN)

% load in rdainfo
pathc_rdawithdata='/home2/jstout/Data/tarquin_matlab_qui/test_data/tarout/rdainfo_withdata.mat';
[FileName,PathName,~]=uigetfile('.','select rdainfo_withdata.mat generated by batch_tarquin.m');
pathc_rdawithdata=[PathName,FileName]; % comment out the this line and the above to hard code pathc_rdawithdata
load(pathc_rdawithdata);
handles.rdainfo=rdainfo;
handles.Nrda=length(rdainfo);

% disable the 30/135 button
set(handles.pushbutton_30or135,'Enable','off')

% intialize vox selector and set initial location to GMR
set(handles.popup_rowcolslice,'Enable','off')
set(handles.popup_rowcolslice,'String','Select Subject')

% set the subject list
rdainfo_table=struct2table(rdainfo);
set(handles.popupmenu_selectsubject,'String',unique(rdainfo_table.pname));

% Choose default command line output for tarquin_visualize
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tarquin_visualize wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = tarquin_visualize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function path_in_Callback(hObject, eventdata, handles)
% hObject    handle to path_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_in as text
%        str2double(get(hObject,'String')) returns contents of path_in as a double



% --- Executes on selection change in popupmenu_selectsubject.
function popupmenu_selectsubject_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_selectsubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_selectsubject contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_selectsubject
val=get(hObject, 'Value');
str=get(hObject, 'String');
rdainfo=handles.rdainfo;
if isfield(rdainfo,'data')
    for i=1:handles.Nrda
        if strcmp(str(val),rdainfo(i).pname)&rdainfo(i).TE==30
            handles.data_struct_30=rdainfo(i).data;
            % set toggle button
            set(handles.pushbutton_30or135,'String','30only')
            set(handles.pushbutton_30or135,'Enable','on')
            handles.rdaidx=i;
        end
        if strcmp(str(val),rdainfo(i).pname)&rdainfo(i).TE==135
            handles.data_struct_135=rdainfo(i).data;
            set(handles.pushbutton_30or135,'String','30')
            set(handles.pushbutton_30or135,'Enable','on')
            handles.rdaidx=i;
        end
        
    end
else
    for i=1:handles.Nrda
        if strcmp(str(val),rdainfo(i).pname)&rdainfo(i).TE==30
            pathc_30=sprintf('/home2/jstout/Data/Cardiac/Spectroscopy/tarout/%s_030_fit.csv',rdainfo(i).pname);
            handles.data_struct_30=tarquin_read_fitcsv(pathc_30);
            % set toggle button
            set(handles.pushbutton_30or135,'String','30only')
            set(handles.pushbutton_30or135,'Enable','on')
            handles.rdaidx=i;
        end
        if strcmp(str(val),rdainfo(i).pname)&rdainfo(i).TE==135
            pathc_135=sprintf('/home2/jstout/Data/Cardiac/Spectroscopy/tarout/%s_135_fit.csv',rdainfo(i).pname);
            handles.data_struct_135=tarquin_read_fitcsv(pathc_135);
            set(handles.pushbutton_30or135,'String','30')
            set(handles.pushbutton_30or135,'Enable','on')
            handles.rdaidx=i;
        end
        
    end
       
end

% reset to GMR location
set(handles.popup_rowcolslice,'String','8,8,4')
set(handles.popup_rowcolslice,'Enable','on')
handles.location=[8,8,4];

plotnow(hObject, handles)
update_output_text(hObject, handles)

% Update handles structure
guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function popupmenu_selectsubject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_selectsubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function popup_rowcolslice_Callback(hObject, eventdata, handles)
% hObject    handle to popup_rowcolslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of popup_rowcolslice as text
%        str2double(get(hObject,'String')) returns contents of popup_rowcolslice as a double

location_str=get(hObject,'String');
handles.location=cell2mat(textscan(location_str,'%f','delimiter',','))';
plotnow(hObject, handles)
update_output_text(hObject, handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popup_rowcolslice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_rowcolslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_30or135.
function pushbutton_30or135_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_30or135 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

state=get(hObject,'String');
switch state
    case '135'
        set(handles.pushbutton_30or135,'String','30')
        plotnow(hObject, handles)
        %         tarquin_plot(handles.data_struct_30,handles.location,'both',handles.axes1,handles.axes2)
        
        update_output_text(hObject, handles)
    case '30'
        set(handles.pushbutton_30or135,'String','135')
        plotnow(hObject, handles)
        %         tarquin_plot(handles.data_struct_135,handles.location,'both',handles.axes1,handles.axes2)
        
        update_output_text(hObject, handles)
end
guidata(hObject, handles);

function update_output_text(hObject,handles)
% this is a little silly, but it gives the display you need, note that this
% is a text edit box that you have disabled that you are writing the
% string to
location=handles.location;
if strcmp(get(handles.pushbutton_30or135,'String'),'30only')
    TE=30;
else
TE=str2num(get(handles.pushbutton_30or135,'String'));
end

pname=get(handles.popupmenu_selectsubject,'String');
pname=pname{get(handles.popupmenu_selectsubject,'Value')};

text_fname=sprintf('/home2/jstout/Data/Cardiac/Spectroscopy/tarout/%s_%03i_txt.txt',pname,TE);
fid=fopen(text_fname,'r');
lines=textscan(fid,'%s','delimiter','\n');
fclose(fid);
N_lines=length(lines{1});
read_lines=0;
text_fit=cell(83,1);
for i=1:N_lines % go through each line
    line=lines{1}{i};
    if read_lines==0 && ~isempty(strfind(line,'Row')) % find row
        R=strfind(line,'Row');
        C=strfind(line,'Col');
        S=strfind(line,'Slice');
        location_file=...
            [str2num(line(R+6:C-1)),str2num(line(C+6:S-1)),str2num(line(S+8:end))];
        if sum(location==location_file)==3 % this is the textblock you want
            read_lines=1;
        end
    end
    if read_lines>0 && read_lines<84
        text_fit{read_lines}=line;
        read_lines=read_lines+1;
    else
        read_lines=0;
    end
end

% pass a cell array of strings as the String property. You might also need to set the Max parameter of the uicontrol to be 2.
set(handles.edit3,'String',text_fit)
guidata(hObject, handles);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'min',0)
set(hObject,'max',2)
set(hObject,'enable','inactive')



% --- Executes on button press in radio_fit.
function radio_fit_Callback(hObject, eventdata, handles)
% hObject    handle to radio_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_fit
plotnow(hObject, handles)

% --- Executes on button press in radio_NAA.
function radio_NAA_Callback(hObject, eventdata, handles)
% hObject    handle to radio_NAA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_NAA
plotnow(hObject, handles)

% --- Executes on button press in radio_tCho.
function radio_tCho_Callback(hObject, eventdata, handles)
% hObject    handle to radio_tCho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_tCho
plotnow(hObject, handles)

% --- Executes on button press in radio_Cr.
function radio_Cr_Callback(hObject, eventdata, handles)
% hObject    handle to radio_Cr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_Cr
plotnow(hObject, handles)

% --- Executes on button press in radio_Lac.
function radio_Lac_Callback(hObject, eventdata, handles)
% hObject    handle to radio_Lac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_Lac
plotnow(hObject, handles)

% --- Executes on button press in radio_GSH.
function radio_GSH_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GSH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GSH
plotnow(hObject, handles)

%%% Helper functions %%%

% Plot the selected metabolites
function plotnow(hObject, handles)
plot_fit=get(handles.radio_fit,'Value');
plot_NAA=get(handles.radio_NAA,'Value');
plot_tCho=get(handles.radio_tCho,'Value');
plot_Cr=get(handles.radio_Cr,'Value');
plot_Lac=get(handles.radio_Lac,'Value');
plot_GSH=get(handles.radio_GSH,'Value');
plot_what=[plot_fit,plot_NAA,plot_tCho,plot_Cr,plot_Lac,plot_GSH];

% What is TE?
TE=get(handles.pushbutton_30or135,'String');
switch TE
    case '30'
        tarquin_plot(handles.data_struct_30,handles.location,plot_what,handles.axes1,handles.axes2);
    case '135'
        tarquin_plot(handles.data_struct_135,handles.location,plot_what,handles.axes1,handles.axes2);
    case '30only'
        tarquin_plot(handles.data_struct_30,handles.location,plot_what,handles.axes1,handles.axes2);
end
