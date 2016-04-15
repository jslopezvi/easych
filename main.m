function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 15-Apr-2016 11:45:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Read logo image
[logo_img,logo_map] = imread('icons/easych.png');
logo_icon = ind2rgb(logo_img,logo_map);
set(handles.logo_pushbutton,'CData',logo_icon);

% Read new icon
[new_img,new_map] = imread('icons/new.png');
new_icon = ind2rgb(new_img,new_map);
set(handles.new_pushbutton,'CData',new_icon);

% Read open icon
[open_img,open_map] = imread('icons/open.png');
open_icon = ind2rgb(open_img,open_map);
set(handles.open_pushbutton,'CData',open_icon);

% Read save icon
[save_img,save_map] = imread('icons/save.png');
save_icon = ind2rgb(save_img,save_map);
set(handles.save_pushbutton,'CData',save_icon);

% Read play icon
[play_img,play_map] = imread('icons/play.png');
play_icon = ind2rgb(play_img,play_map);
set(handles.play_pushbutton,'CData',play_icon);

% Read record icon
[record_img,record_map] = imread('icons/record.png');
record_icon = ind2rgb(record_img,record_map);
set(handles.record_pushbutton,'CData',record_icon);

% Read load icon
[load_img,load_map] = imread('icons/load.png');
load_icon = ind2rgb(load_img,load_map);
set(handles.load_pushbutton,'CData',load_icon);

% Init heart icon
[heart_img,heart_map] = imread('icons/heart_64.png');
heart_icon = ind2rgb(heart_img,heart_map);
set(handles.heart_pushbutton,'CData',heart_icon);

% Init lungs icon
[lungs_img,lungs_map] = imread('icons/lungs_64.png');
lungs_icon = ind2rgb(lungs_img,lungs_map);
set(handles.respiratory_pushbutton,'CData',lungs_icon);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.easych_figure);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in new_pushbutton.
function new_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to new_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in open_pushbutton.
function open_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to open_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in logo_pushbutton.
function logo_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to logo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in plot_type_axes.
function plot_type_axes_Callback(hObject, eventdata, handles)
% hObject    handle to plot_type_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plot_type_axes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plot_type_axes


% --- Executes during object creation, after setting all properties.
function plot_type_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_type_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hor_pan_check.
function hor_pan_check_Callback(hObject, eventdata, handles)
% hObject    handle to hor_pan_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hor_pan_check


% --- Executes on selection change in comport_pop.
function comport_pop_Callback(hObject, eventdata, handles)
% hObject    handle to comport_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comport_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comport_pop


% --- Executes during object creation, after setting all properties.
function comport_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comport_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in baudrate_pop.
function baudrate_pop_Callback(hObject, eventdata, handles)
% hObject    handle to baudrate_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns baudrate_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from baudrate_pop


% --- Executes during object creation, after setting all properties.
function baudrate_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baudrate_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in heart_pushbutton.
function heart_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to heart_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in respiratory_pushbutton.
function respiratory_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to respiratory_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in play_pushbutton.
function play_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to play_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function first_name_txt_Callback(hObject, eventdata, handles)
% hObject    handle to first_name_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of first_name_txt as text
%        str2double(get(hObject,'String')) returns contents of first_name_txt as a double


% --- Executes during object creation, after setting all properties.
function first_name_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to first_name_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function last_name_txt_Callback(hObject, eventdata, handles)
% hObject    handle to last_name_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of last_name_txt as text
%        str2double(get(hObject,'String')) returns contents of last_name_txt as a double


% --- Executes during object creation, after setting all properties.
function last_name_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to last_name_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sex_pop.
function sex_pop_Callback(hObject, eventdata, handles)
% hObject    handle to sex_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sex_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sex_pop


% --- Executes during object creation, after setting all properties.
function sex_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sex_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function age_txt_Callback(hObject, eventdata, handles)
% hObject    handle to age_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of age_txt as text
%        str2double(get(hObject,'String')) returns contents of age_txt as a double


% --- Executes during object creation, after setting all properties.
function age_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to age_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function weight_txt_Callback(hObject, eventdata, handles)
% hObject    handle to weight_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weight_txt as text
%        str2double(get(hObject,'String')) returns contents of weight_txt as a double


% --- Executes during object creation, after setting all properties.
function weight_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weight_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_txt_Callback(hObject, eventdata, handles)
% hObject    handle to height_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height_txt as text
%        str2double(get(hObject,'String')) returns contents of height_txt as a double


% --- Executes during object creation, after setting all properties.
function height_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function national_id_txt_Callback(hObject, eventdata, handles)
% hObject    handle to national_id_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of national_id_txt as text
%        str2double(get(hObject,'String')) returns contents of national_id_txt as a double


% --- Executes during object creation, after setting all properties.
function national_id_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to national_id_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function email_txt_Callback(hObject, eventdata, handles)
% hObject    handle to email_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of email_txt as text
%        str2double(get(hObject,'String')) returns contents of email_txt as a double


% --- Executes during object creation, after setting all properties.
function email_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to email_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phone_txt_Callback(hObject, eventdata, handles)
% hObject    handle to phone_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phone_txt as text
%        str2double(get(hObject,'String')) returns contents of phone_txt as a double


% --- Executes during object creation, after setting all properties.
function phone_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phone_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function address_txt_Callback(hObject, eventdata, handles)
% hObject    handle to address_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of address_txt as text
%        str2double(get(hObject,'String')) returns contents of address_txt as a double


% --- Executes during object creation, after setting all properties.
function address_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to address_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function relevant_clinical_history_txt_Callback(hObject, eventdata, handles)
% hObject    handle to relevant_clinical_history_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of relevant_clinical_history_txt as text
%        str2double(get(hObject,'String')) returns contents of relevant_clinical_history_txt as a double


% --- Executes during object creation, after setting all properties.
function relevant_clinical_history_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to relevant_clinical_history_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_alarm_pushbutton.
function show_alarm_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to show_alarm_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function alarms_obs_txt_Callback(hObject, eventdata, handles)
% hObject    handle to alarms_obs_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alarms_obs_txt as text
%        str2double(get(hObject,'String')) returns contents of alarms_obs_txt as a double


% --- Executes during object creation, after setting all properties.
function alarms_obs_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alarms_obs_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compute_hrv_pushbutton.
function compute_hrv_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to compute_hrv_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in show_recording_pushbutton.
function show_recording_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to show_recording_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in record_pushbutton.
function record_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to record_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in load_pushbutton.
function load_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function fs_txt_Callback(hObject, eventdata, handles)
% hObject    handle to fs_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs_txt as text
%        str2double(get(hObject,'String')) returns contents of fs_txt as a double


% --- Executes during object creation, after setting all properties.
function fs_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
