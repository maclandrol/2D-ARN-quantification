function varargout = MergeQuant(varargin)
% MERGEQUANT MATLAB code for MergeQuant.fig
%      MERGEQUANT, by itself, creates a new MERGEQUANT or raises the existing
%      singleton*.
%
%      H = MERGEQUANT returns the handle to a new MERGEQUANT or the handle to
%      the existing singleton*.
%
%      MERGEQUANT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MERGEQUANT.M with the given input arguments.
%
%      MERGEQUANT('Property','Value',...) creates a new MERGEQUANT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MergeQuant_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MergeQuant_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MergeQuant

% Last Modified by GUIDE v2.5 08-Jul-2013 15:35:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MergeQuant_OpeningFcn, ...
                   'gui_OutputFcn',  @MergeQuant_OutputFcn, ...
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


% --- Executes just before MergeQuant is made visible.
function MergeQuant_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MergeQuant (see VARARGIN)

% Choose default command line output for MergeQuant
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MergeQuant wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MergeQuant_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function cell2merge_Callback(hObject, eventdata, handles)
% hObject    handle to cell2merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell2merge as text
%        str2double(get(hObject,'String')) returns contents of cell2merge as a double


% --- Executes during object creation, after setting all properties.
function cell2merge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell2merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function out1_Callback(hObject, eventdata, handles)
% hObject    handle to out1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of out1 as text
%        str2double(get(hObject,'String')) returns contents of out1 as a double


% --- Executes during object creation, after setting all properties.
function out1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to out1 (see GCBO)
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


% --- Executes on button press in bcell.
function bcell_Callback(hObject, eventdata, handles)
% hObject    handle to bcell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.tif;*.tiff','Microscopy image file'; '*.*','All (*.*)'}, 'Pick the Cell file');
cells= fullfile(pathname, file);
set(handles.cell, 'String', cells);


% --- Executes on button press in bnuc.
function bnuc_Callback(hObject, eventdata, handles)
% hObject    handle to bnuc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.tif;*.tiff','Microscopy image file'; '*.*','All (*.*)'}, 'Pick the Nucleus file');
nucleus= fullfile(pathname, file);
set(handles.nuc, 'String', nucleus);

% --- Executes on button press in barn.
function barn_Callback(hObject, eventdata, handles)
% hObject    handle to barn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.loc','Localize file (.loc)'; '*.*','All (*.*)'}, 'Pick the ARN file');
arn= fullfile(pathname, file);
set(handles.arn, 'String', arn);

% --- Executes on button press in bcell2merge.
function bcell2merge_Callback(hObject, eventdata, handles)
% hObject    handle to bcell2merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.fus','Fusion file (.fus)'; '*.*','All (*.*)'}, 'Pick the ARN file');
merge= fullfile(pathname, file);
set(handles.cell2merge, 'String', merge);

% --- Executes on button press in bout1.
function bout1_Callback(hObject, eventdata, handles)
% hObject    handle to bout1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.txt','Text file (.txt)'; '*.*','All (*.*)'}, 'Pick the ARN file');
out1= fullfile(pathname, file);
set(handles.out1, 'String', out1);

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg('Are you sure you want to exit the program?',...
    'Close Request','Yes','No','Yes');
switch selection
    case 'Yes',
        close all;
    case 'No'
        return
end %switch

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center = (get(handles.center, 'String'));
threshold= (str2double(get(handles.threshold, 'String')));
ARNfile= (get(handles.arn, 'String'));
Cell = (get(handles.cell, 'String'));
Nuc = (get(handles.nuc, 'String'));
previousOut1= get(handles.out1, 'String');
cell2merge= get(handles.cell2merge, 'String');
mergeandquant(cell2merge,Cell,Nuc,previousOut1,ARNfile,threshold,center);
close all;
