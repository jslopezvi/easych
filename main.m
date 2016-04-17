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
%      existing singlet           on*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 15-Apr-2016 16:26:58

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

% Init EasyCH project struct
global easych_project;
handles.easych_project = struct;

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

% Init Alarm icon
[alarm_img,alarm_map] = imread('icons/alarm.png');
alarm_icon = ind2rgb(alarm_img,alarm_map);
set(handles.alarm_pushbutton,'CData',alarm_icon);

% Init HRV Tables
% Time measures
handles.time_table.Data = {'SDNN',sprintf('%0.2f',0);'SDANN',sprintf('%0.2f',0);'RMSSD',sprintf('%0.2f',0);'SDSD',sprintf('%0.2f',0);'pNN50',sprintf('%0.2f%%',0);};

% Frequency measures
handles.freq_table.Data = {'HF',sprintf('%0.2f',0);'LF',sprintf('%0.2f',0);'VLF',sprintf('%0.2f',0);'ULF',sprintf('%0.2f',0);'LF/HF',sprintf('%0.2f',0);};

% Save play button status
handles.play_pressed = 0;

% Set online monitoring flag
handles.monitoring = 0;

% Selected row indices for recording and alarms tables.
handles.current_row_alarms_table = 0;
handles.current_row_recordings_table = 0;

% Init monitoring_timer
handles.monitoring_timer = 0;

% Init serial port
handles.serial_port = 0;

% Init elapsed time
handles.elapsed_time = 0;

% Init ecg record
handles.current_record = struct;
handles.current_record.data = [];

% Init recordings_table
handles.recordings = {};
handles.recordings_table.Data = {};

% Init recordings_table
handles.alarms = {};
handles.alarms_table.Data = {};

% Init panels states
% Hide axes
set(handles.monitoring_axes, 'Visible','off');
set(handles.heart_rate_axes, 'Visible','off');
set(handles.respiratory_rate_axes, 'Visible','off');

% Disable panels
set(findall(handles.monitoring_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.clinical_history_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'off');

set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'off');
set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'off');

set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_alarm_pushbutton, '-property', 'enable'), 'enable', 'off');

movegui(hObject,'center');

% Update handles structure
guidata(hObject, handles);

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
handles = guidata(hObject);

handles.project_name = strcat('easych_',strrep(strrep(datestr(datetime('now')), ' ', '_'),':','_'),'.ech');
set(handles.project_txt, 'String', handles.project_name);

% Show axes
set(handles.monitoring_axes, 'Visible','on');
set(handles.heart_rate_axes, 'Visible','on');
set(handles.respiratory_rate_axes, 'Visible','on');

set(findall(handles.monitoring_panel, '-property', 'enable'), 'enable', 'on');
set(findall(handles.clinical_history_panel, '-property', 'enable'), 'enable', 'on');
set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'off');

set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'off');
set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'off');

set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_alarm_pushbutton, '-property', 'enable'), 'enable', 'off');

drawnow;
set(findall(handles.save_pushbutton, '-property', 'enable'), 'enable', 'on');
guidata(hObject, handles);

% --- Executes on button press in open_pushbutton.
function open_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to open_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
[FileName,PathName] = uigetfile('projects/*.ech','Please select EasyCH project file...');
handles.project_name = FileName;
handles.project_path = PathName;
set(handles.project_txt, 'String', handles.project_name);

handles.easych_project = load(strcat(PathName, FilePath));
easych_project = handles.easych_project;

set(findall(handles.save_pushbutton, '-property', 'enable'), 'enable', 'on');
guidata(hObject, handles);


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
[FileName,PathName] = uiputfile(strcat('projects/',handles.project_name),'Please set path for saving EasyCH project file...');

handles.easych_project.test_value1 = 12341234;
handles.easych_project.test_value2 = 5555;

if(numel(FileName) > 0),
    if( exist(strcat(PathName,FileName),'file') ),
        choice = questdlg('Do you want to overwrite file?', ...
        'File Overwrite', ...
        'Yes','No','No');

        if (strcmp(choice,'Yes') == 1),
            handles.project_name = FileName;
            handles.project_path = PathName;

            easych_project = handles.easych_project;
            save(strcat(PathName,FileName), 'easych_project');
        else
            return;
        end    
    else
        handles.project_name = FileName;
        handles.project_path = PathName;

        easych_project = handles.easych_project;
        save(strcat(PathName,FileName), 'easych_project');
    end
end

guidata(hObject, handles);


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

switch get(handles.plot_type_axes,'Value')
    case 1 % HRV
        fprintf('Selected HRV plot type\n');
        set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'on');        
        set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'off');
    case 2 % Online
        fprintf('Selected Online plot type\n');
        set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'on');
    case 3 % Alarm Viewer
        fprintf('Selected AlarmViewer plot type\n');
        set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'off');
    otherwise % File Record
        fprintf('Selected FileRecord plot type\n');
        set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'on');
end

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

function [bytes,byte_counter] = read_serialport(hObject)
handles = guidata(hObject);
if(isvalid(handles.serial_port) && strcmp(handles.serial_port.Status,'open') == 1),
    if(handles.serial_port.BytesAvailable > 0),
        bytes_read = fread(handles.serial_port,handles.serial_port.BytesAvailable,'uint8');    
        n = numel(bytes_read);

        byte_counter = 0;    
        bytes = zeros(1,n/4);

        for i=1:n/4, % Discard all data that is not exact multiple of 4
            byte_counter = byte_counter + 1;
            base_index = 4*(byte_counter-1) + 1;

            v1 = bitshift(bytes_read(base_index+0),8*3); % Most significant byte
            v2 = bitshift(bytes_read(base_index+1),8*2);
            v3 = bitshift(bytes_read(base_index+2),8*1);
            v4 = bitshift(bytes_read(base_index+3),8*0); % Less significant byte

            bytes(byte_counter) = v1 + v2 + v3 + v4;
        end
    else
        bytes = [];
        byte_counter = 0;
    end
end

function timer_callback(timerHandle,timerData)
% Read handles
handles = guidata(timerHandle.UserData);
if(handles.monitoring == 1),        
    handles.elapsed_time = handles.elapsed_time + 1;
    
    fprintf('Running timer... Elapsed time %d\n',handles.elapsed_time);
    fprintf('Running timer callback at %s...\n',datestr(timerData.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF'));
    
    % Read serial port
    [bytes,byte_counter] = read_serialport(timerHandle.UserData);
    
    if(byte_counter > 0),
        % Compute start and end indexes.
        start_index = numel(handles.current_record.data);
        handles.current_record.data = [handles.current_record.data bytes];        
        guidata(timerHandle.UserData, handles);

        w = 100;
        
        miny = min(handles.current_record.data);
        maxy = max(handles.current_record.data);
        
        start_i = 1;

        fprintf('byte_counter = %d\n',byte_counter);
        
        for i = 1:byte_counter;
            handles = guidata(timerHandle.UserData);                        
            h = handles.current_monitoring_axes;
            
            cla(h);

            if(i > w)
                start_i = i-w;
            end
            
            end_i = i;

            plot(h, start_index+start_i:start_index+end_i, handles.current_record.data(start_index+start_i:start_index+end_i));
            plot(h, start_index+i, handles.current_record.data(start_index+i), 'or');
            
            xlim(h, [start_index+i-w,start_index+i+w]);
            ylim(h, [miny,maxy]);

            drawnow;
        end 
    end    
else
    if(timerHandle ~= 0),
        stop(timerHandle);
    end    
end
% Update handles
guidata(timerHandle.UserData, handles);

% --- Executes on button press in play_pushbutton.
function play_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to play_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.play_pressed == 0),
    % Read serial port
    serial_port_coms = get(handles.comport_pop,'String');
    serial_port_com_val = get(handles.comport_pop,'Value');
    serial_port_baudrates = get(handles.baudrate_pop,'String');
    serial_port_baudrate_val = get(handles.baudrate_pop,'Value');
    
    serial_port_com = serial_port_coms(serial_port_com_val);
    serial_port_baudrate = serial_port_baudrates(serial_port_baudrate_val);
    
    handles.serial_port = serial(serial_port_com{:},'BaudRate',str2double(serial_port_baudrate),'DataBits',8);
    handles.serial_port.InputBufferSize = 50000;
    
    try
        if(strcmp(handles.serial_port.Status,'open') == 1),
            fclose(handles.serial_port);
        end
        
        fopen(handles.serial_port);
    catch ME
        msgbox(sprintf('Cannot connect to serial port %s, %s',serial_port_com{:},ME.message),'Serial port error','error');
        return;
    end

    msgbox(sprintf('Successfully connected to %s!',serial_port_com{:}),'Successful connection to serial port','help');
    
    % Read sampling frequency
    fs = str2double(get(handles.fs_txt,'String'));
    
    if(isnan(fs)),
        msgbox('Plese give a numeric value (decimal values separated by dot (.)) for sampling frequency Fs!','Error with sampling frequency','error');
        return;
    end
    
    % Set monitoring flag
    handles.monitoring = 1;
    handles.play_pressed = 1;
    
    % Read pause icon
    [pause_img,pause_map] = imread('icons/pause.png');
    pause_icon = ind2rgb(pause_img,pause_map);
    set(handles.play_pushbutton,'CData',pause_icon);
    drawnow;
    
    handles.current_monitoring_axes = handles.monitoring_axes;
    guidata(hObject, handles);
    
    handles.monitoring_timer = timer;
    handles.monitoring_timer.StartDelay = 0;
    
    % Reduce the speed in a factor of 10
    handles.monitoring_timer.Period = 10/fs;
    handles.monitoring_timer.BusyMode = 'drop';
    handles.monitoring_timer.ExecutionMode = 'fixedRate';
    handles.monitoring_timer.TimerFcn = @timer_callback;
    
    guidata(hObject, handles);
    
    handles.monitoring_timer.UserData = hObject;
    
    grid(handles.current_monitoring_axes, 'off');
    grid(handles.current_monitoring_axes, 'on');
    grid(handles.current_monitoring_axes, 'minor');
    hold(handles.current_monitoring_axes, 'on');
    
    start(handles.monitoring_timer);

    if(isvalid(hObject)),
        guidata(hObject, handles);
    end
elseif(handles.play_pressed == 1),
    handles.monitoring = 0;
    handles.play_pressed = 0;
    handles.monitoring_timer.UserData = hObject;
    guidata(hObject, handles);
    
    [play_img,play_map] = imread('icons/play.png');
    play_icon = ind2rgb(play_img,play_map);
    set(handles.play_pushbutton,'CData',play_icon);
    drawnow;
    
    handles.current_monitoring_axes = handles.hidden_axes;
    handles.monitoring_timer.UserData = hObject;
    
    stop(handles.monitoring_timer);
    
    if(isvalid(handles.serial_port) && strcmp(handles.serial_port.Status,'open') == 1),
        fclose(handles.serial_port);
        delete(handles.serial_port);
        msgbox('Successfully disconnected!','Successful disconnection to serial port','help');
    end
    
    disp('Timer stopped!');
    guidata(hObject, handles);
else
    msgbox('Unkown monitoring status!','Warning','war');
end


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
handles = guidata(hObject);

if(handles.current_row_alarms_table ~= 0),
    msgbox(sprintf('Showing alarm # %d', handles.current_row_alarms_table), 'Info', 'help');
else
    msgbox(sprintf('No alarm to show!'), 'Info', 'help');
end




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
handles = guidata(hObject);

if(handles.current_row_recordings_table ~= 0),
    msgbox(sprintf('Showing recording # %d', handles.current_row_recordings_table), 'Info', 'help');
else
    msgbox(sprintf('No recording to show!'), 'Info', 'help');
end


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


% --- Executes on button press in alarm_pushbutton.
function alarm_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to alarm_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in recordings_table.
function recordings_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to recordings_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

fprintf('Current row selected on recordings table:');
disp(eventdata.Indices(1));
handles.current_row_recordings_table = eventdata.Indices(1);
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in alarms_table.
function alarms_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to alarms_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

fprintf('Current row selected on alarms table:');
disp(eventdata.Indices(1));
handles.current_row_alarms_table = eventdata.Indices(1);
guidata(hObject, handles);


% --- Executes when user attempts to close easych_figure.
function easych_figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to easych_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

% Stop timer if present
if(handles.monitoring_timer ~= 0),
    stop(handles.monitoring_timer);
end

% Close and delete serial port if present
if(handles.serial_port ~= 0),
    if(isvalid(handles.serial_port) && strcmp(handles.serial_port.Status,'open') == 1),
        fclose(handles.serial_port);
        delete(handles.serial_port);
    end
end

% Hint: delete(hObject) closes the figure
delete(hObject);
