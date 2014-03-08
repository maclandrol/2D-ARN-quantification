function varargout = ARNQuant(varargin)
% ARNQUANT MATLAB code for ARNQuant.fig
%      ARNQUANT, by itself, creates a new ARNQUANT or raises the existing
%      singleton*.
%
%      H = ARNQUANT returns the handle to a new ARNQUANT or the handle to
%      the existing singleton*.
%
%      ARNQUANT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARNQUANT.M with the given input arguments.
%
%      ARNQUANT('Property','Value',...) creates a new ARNQUANT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ARNQuant_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ARNQuant_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ARNQuant

% Last Modified by GUIDE v2.5 31-Aug-2013 16:19:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ARNQuant_OpeningFcn, ...
                   'gui_OutputFcn',  @ARNQuant_OutputFcn, ...
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


% --- Executes just before ARNQuant is made visible.
function ARNQuant_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ARNQuant (see VARARGIN)

% Choose default command line output for ARNQuant
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ARNQuant wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ARNQuant_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in okbutton.
function okbutton_Callback(hObject, eventdata, handles)
% hObject    handle to okbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center = (get(handles.center, 'String'));
filtre =(get(handles.filtre, 'String'));
clseg =(get(handles.clseg, 'String'));
threshold= (str2double(get(handles.threshold, 'String')));
ARNfile= (get(handles.arn, 'String'));
Cell = (get(handles.cell, 'String'));
Nuc = (get(handles.nuc, 'String'));
ARN_quant(Cell,Nuc,ARNfile,threshold,center,filtre, clseg);
close all;

% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg('Are you sure you want to close this program?',...
    'Close Request','Yes','No','Yes');
switch selection
    case 'Yes',
        close all;
    case 'No'
        return
end %switch


function cell_Callback(hObject, eventdata, handles)
% hObject    handle to cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell as text
%        str2double(get(hObject,'String')) returns contents of cell as a double


% --- Executes during object creation, after setting all properties.
function cell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browsearn.
function browsearn_Callback(hObject, eventdata, handles)
% hObject    handle to browsearn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.loc','Localize file (.loc)'; '*.*','All (*.*)'}, 'Pick the ARN file');
arn= fullfile(pathname, file);
set(handles.arn, 'String', arn);

% --- Executes on button press in browsenuc.
function browsenuc_Callback(hObject, eventdata, handles)
% hObject    handle to browsenuc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.tif;*.tiff','Microscopy image file'; '*.*','All (*.*)'}, 'Pick the Nucleus file');
nucleus= fullfile(pathname, file);
set(handles.nuc, 'String', nucleus);


function arn_Callback(hObject, eventdata, handles)
% hObject    handle to arn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of arn as text
%        str2double(get(hObject,'String')) returns contents of arn as a double


% --- Executes during object creation, after setting all properties.
function arn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browsecell.
function browsecell_Callback(hObject, eventdata, handles)
% hObject    handle to browsecell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.tif;*.tiff','Microscopy image file'; '*.*','All (*.*)'}, 'Pick the Cell file');
cells= fullfile(pathname, file);
set(handles.cell, 'String', cells);


function nuc_Callback(hObject, eventdata, handles)
% hObject    handle to nuc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nuc as text
%        str2double(get(hObject,'String')) returns contents of nuc as a double


% --- Executes during object creation, after setting all properties.
function nuc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nuc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double


% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function center_Callback(hObject, eventdata, handles)
% hObject    handle to center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of center as text
%        str2double(get(hObject,'String')) returns contents of center as a double


% --- Executes during object creation, after setting all properties.
function center_CreateFcn(hObject, eventdata, handles)
% hObject    handle to center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filtre_Callback(hObject, eventdata, handles)
% hObject    handle to filtre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtre as text
%        str2double(get(hObject,'String')) returns contents of filtre as a double


% --- Executes during object creation, after setting all properties.
function filtre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over cancelbutton.
function cancelbutton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function clseg_Callback(hObject, eventdata, handles)
% hObject    handle to clseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clseg as text
%        str2double(get(hObject,'String')) returns contents of clseg as a double


% --- Executes during object creation, after setting all properties.
function clseg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function print_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)
