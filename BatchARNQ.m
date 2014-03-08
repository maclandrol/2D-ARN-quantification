function varargout = BatchARNQ(varargin)
% BATCHARNQ MATLAB code for BatchARNQ.fig
%      BATCHARNQ, by itself, creates a new BATCHARNQ or raises the existing
%      singleton*.
%
%      H = BATCHARNQ returns the handle to a new BATCHARNQ or the handle to
%      the existing singleton*.
%
%      BATCHARNQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCHARNQ.M with the given input arguments.
%
%      BATCHARNQ('Property','Value',...) creates a new BATCHARNQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BatchARNQ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BatchARNQ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BatchARNQ

% Last Modified by GUIDE v2.5 28-Jun-2013 16:03:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BatchARNQ_OpeningFcn, ...
                   'gui_OutputFcn',  @BatchARNQ_OutputFcn, ...
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


% --- Executes just before BatchARNQ is made visible.
function BatchARNQ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BatchARNQ (see VARARGIN)

% Choose default command line output for BatchARNQ
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BatchARNQ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BatchARNQ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function expdossier_Callback(hObject, eventdata, handles)
% hObject    handle to expdossier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of expdossier as text
%        str2double(get(hObject,'String')) returns contents of expdossier as a double


% --- Executes during object creation, after setting all properties.
function expdossier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expdossier (see GCBO)
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


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg('Are you sure you want to leave me? (I''ll cry)',...
    'Close Request','Yes','No','Yes');
switch selection
    case 'Yes',
        close all;
    case 'No'
        return
end %switch


% --- Executes on button press in okbutton.
function okbutton_Callback(hObject, eventdata, handles)
% hObject    handle to okbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path= get(handles.expdossier, 'String');
center= get(handles.center, 'String');
threshold= str2num(get(handles.threshold, 'String'));
matbatch(path, center, threshold');
%close all;

% --- Executes on button press in browsedir.
function browsedir_Callback(hObject, eventdata, handles)
% hObject    handle to browsedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directname= strcat(uigetdir('', 'Choose your directory'),'/');
set(handles.expdossier, 'String', directname);