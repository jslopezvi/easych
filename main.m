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

% Last Modified by GUIDE v2.5 20-Apr-2016 17:39:44

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
global easych_project; %#ok<*NUSED>
handles.easych_project = struct;

% Add paths
addpath('fx');

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

% Read stop icon
[stop_img,stop_map] = imread('icons/stop.png');
stop_icon = ind2rgb(stop_img,stop_map);
set(handles.stop_pushbutton,'CData',stop_icon);

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

% Selected row indices for recording and alarms tables.
handles.current_row_alarms_table = 0;
handles.current_row_recordings_table = 0;

% Init monitoring variables
% Init monitoring_timer
handles.monitoring_timer = 0;

% Init serial port
handles.serial_port = 0;

% Init elapsed time
handles.elapsed_time = 0;

% Init ecg record
handles.record_data = [];

% Flag for training ECG recording
handles.training = 0;

% Time window for analysis
handles.time_window_for_analysis = 0;

% Training time in seconds
handles.training_time = 0;

% Time between samples.
handles.time_per_sample = 0;

% Number of samples per time window.
handles.number_of_samples_per_time_window = 0;

% Number of time windows for training
handles.number_of_time_windows_for_training = 0;

% Filter threshold
handles.filter_threshold = 0;

% Init recordings_table
handles.recordings = {};
handles.current_recording_index = 0;
handles.current_recording_name = '';
handles.current_recording_path = '';
handles.recordings_table.Data = {};

% Init recordings_table
handles.alarms = {};
handles.alarms_table.Data = {};

% Init ecg_analysis variables
handles.ecg_analysis = {};
handles.samples_processed_counter = 0;

% Heart rates
handles.HRs = [];

% Respiration rates
handles.BRs = [];

% Representative rate times
handles.Rts = [];

% Fiducial points for all the signal recording
handles.Pons = [];
handles.Poffs = [];
handles.Qons = [];
handles.Rpeaks = [];
handles.Soffs = [];
handles.Tons = [];
handles.Toffs = [];

% Start indexes for analysis and plotting
handles.start_index_for_analysis = 0;
handles.start_index_for_plotting = 0;

% Save current heart rate and respiratory rate.
handles.current_hr = -100;
handles.current_hr_step = 0;
handles.current_hr_cum = 0;
handles.current_br = -100;
handles.current_br_step = 0;
handles.current_br_cum = 0;

% Init alarm types and descriptions
type1 = 'Tachycardia';
type2 = 'Bradycardia';
type3 = 'Tachypnoea';
type4 = 'Bradypnoea';
type5 = 'QT Arrhythmia';
type6 = 'QRS Arrhythmia';
type7 = 'RR Arrhythmia';
type8 = 'Ischemia';

type1_desc = 'High Heart Rate. HR over 120 beats per minute';
type2_desc = 'Low Heart Rate. HR under 30 beats per minute';
type3_desc = 'High Respiratory Rate. BR over 30 respirations per minute';
type4_desc = 'Low Respiratory Rate. BR under 6 respirations per minute';
type5_desc = 'Loss of normal conduction, QT segment larger than 0.5 segs';
type6_desc = 'Loss of normal conduction, QRS segment larger than 0.12 segs';
type7_desc = 'Loss of normal conduction, RR interval larger than 4 segs';
type8_desc = 'T wave inverted';

handles.alarms_names = {type1; type2; type3; type4; type5; type6; type7; type8};
handles.alarms_descriptions = {type1_desc; type2_desc; type3_desc; type4_desc; type5_desc; type6_desc; type7_desc; type8_desc};

% Load heart icons
heart32_img = imread('icons/heart_32.png');
handles.heart32_icon = heart32_img;

[heart64_img,heart64_map] = imread('icons/heart_64.png');
handles.heart64_icon = ind2rgb(heart64_img,heart64_map);

% Load lungs icons
lungs32_img = imread('icons/lungs_32.png');
handles.lungs32_icon = lungs32_img;

[lungs64_img,lungs64_map] = imread('icons/lungs_64.png');
handles.lungs64_icon = ind2rgb(lungs64_img,lungs64_map);

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
set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.recordings_table, '-property', 'enable'), 'enable', 'off');

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

set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'on');
set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'on');

set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.recordings_table, '-property', 'enable'), 'enable', 'off');
set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');

drawnow;
set(findall(handles.save_pushbutton, '-property', 'enable'), 'enable', 'on');

set(handles.file_record_txt, 'String', '');
set(handles.heart_label, 'String', '');
set(handles.respiratory_label, 'String', '');
set(handles.delay_value, 'String', '');

set(handles.first_name_txt,'String', '');
set(handles.last_name_txt,'String', '');
set(handles.sex_pop,'Value', 1);
set(handles.age_txt,'String', '');
set(handles.weight_txt,'String', '');
set(handles.height_txt,'String', '');
set(handles.email_txt,'String', '');
set(handles.phone_txt,'String', '');
set(handles.address_txt,'String', '');
set(handles.national_id_txt,'String', '');
set(handles.relevant_clinical_history_txt,'String', '');

set(handles.alarms_obs_txt,'String', '');
        
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

handles.easych_project = load(strcat(PathName,FileName),'-mat','easych_project');
handles.easych_project = handles.easych_project.easych_project;
easych_project = handles.easych_project; %#ok<NASGU>

handles.recordings = handles.easych_project.recordings;
set(handles.recordings_table, 'Data', handles.recordings);

handles.alarms = {};
set(handles.alarms_table, 'Data', handles.alarms);

handles.fs = handles.easych_project.fs;
set(handles.fs_txt, 'String', sprintf('%d',handles.fs));
drawnow;

set(handles.first_name_txt,'String',handles.easych_project.patient_info.first_name);
set(handles.last_name_txt,'String',handles.easych_project.patient_info.last_name);
set(handles.sex_pop,'Value',handles.easych_project.patient_info.genre);
set(handles.age_txt,'String',handles.easych_project.patient_info.age);
set(handles.weight_txt,'String',handles.easych_project.patient_info.weight);
set(handles.height_txt,'String',handles.easych_project.patient_info.height);
set(handles.email_txt,'String',handles.easych_project.patient_info.email);
set(handles.phone_txt,'String',handles.easych_project.patient_info.phone);
set(handles.address_txt,'String',handles.easych_project.patient_info.address);
set(handles.national_id_txt,'String',handles.easych_project.patient_info.national_id);
set(handles.relevant_clinical_history_txt,'String',handles.easych_project.patient_info.relevant_clinical_history_txt);

set(handles.alarms_obs_txt,'String',handles.easych_project.alarms_obs);

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

set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'on');
set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'on');

set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.recordings_table, '-property', 'enable'), 'enable', 'off');
set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');

drawnow;
set(findall(handles.save_pushbutton, '-property', 'enable'), 'enable', 'on');

set(handles.file_record_txt, 'String', '');
set(handles.heart_label, 'String', '');
set(handles.respiratory_label, 'String', '');
set(handles.delay_value, 'String', '');
        
guidata(hObject, handles);


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
[FileName,PathName] = uiputfile(strcat('projects/',handles.project_name),'Please set path for saving EasyCH project file...');

handles.easych_project.patient_info = struct;
handles.easych_project.patient_info.first_name = get(handles.first_name_txt,'String');
handles.easych_project.patient_info.last_name = get(handles.last_name_txt,'String');
handles.easych_project.patient_info.genre = get(handles.sex_pop,'Value');
handles.easych_project.patient_info.age = get(handles.age_txt,'String');
handles.easych_project.patient_info.weight = get(handles.weight_txt,'String');
handles.easych_project.patient_info.height = get(handles.height_txt,'String');
handles.easych_project.patient_info.email = get(handles.email_txt,'String');
handles.easych_project.patient_info.phone = get(handles.phone_txt,'String');
handles.easych_project.patient_info.address = get(handles.address_txt,'String');
handles.easych_project.patient_info.national_id = get(handles.national_id_txt,'String');
handles.easych_project.patient_info.relevant_clinical_history_txt = get(handles.relevant_clinical_history_txt,'String');

handles.easych_project.alarms_obs = get(handles.alarms_obs_txt,'String');

handles.easych_project.recordings = handles.recordings;
handles.easych_project.fs = handles.fs;

if(FileName ~= 0),
    handles.project_name = FileName;
    handles.project_path = PathName;

    easych_project = handles.easych_project; %#ok<NASGU>
    save(strcat(PathName,FileName), 'easych_project');
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
    case 1 % HRV Record
        reset(handles.monitoring_axes);
        cla(handles.monitoring_axes);
        cla(handles.heart_rate_axes);
        cla(handles.respiratory_rate_axes);
        legend(handles.monitoring_axes, 'hide');
        
        set(handles.file_record_txt, 'String', '');       
        set(handles.heart_label, 'String', '');
        set(handles.respiratory_label, 'String', '');
        set(handles.delay_value, 'String', '');
        
        set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'off');        
        set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'on');
        
        set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.recordings_table, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_obs_txt, '-property', 'enable'), 'enable', 'off');
        
        set(findall(handles.load_pushbutton, '-property', 'enable'), 'enable', 'on');

    case 2 % Online
        reset(handles.monitoring_axes);
        cla(handles.monitoring_axes);
        cla(handles.heart_rate_axes);
        cla(handles.respiratory_rate_axes);
        legend(handles.monitoring_axes, 'hide');
        
        set(handles.file_record_txt, 'String', '');
        set(handles.heart_label, 'String', '');
        set(handles.respiratory_label, 'String', '');
        set(handles.delay_value, 'String', '');
        
        set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'on');
        
        set(findall(handles.play_pushbutton, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.stop_pushbutton, '-property', 'enable'), 'enable', 'off');
        
        set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.recordings_table, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_obs_txt, '-property', 'enable'), 'enable', 'off');
        
        set(findall(handles.load_pushbutton, '-property', 'enable'), 'enable', 'off');
    case 3 % Recordings
        reset(handles.monitoring_axes);
        cla(handles.monitoring_axes);
        cla(handles.heart_rate_axes);
        cla(handles.respiratory_rate_axes);
        legend(handles.monitoring_axes, 'hide');
        
        set(handles.file_record_txt, 'String', '');
        set(handles.heart_label, 'String', '');
        set(handles.respiratory_label, 'String', '');
        set(handles.delay_value, 'String', '');
        
        set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'off');        
        
        set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.recordings_table, '-property', 'enable'), 'enable', 'on');
        
        set(findall(handles.load_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_obs_txt, '-property', 'enable'), 'enable', 'on');
        
    otherwise % ECG Record
        reset(handles.monitoring_axes);
        cla(handles.monitoring_axes);
        cla(handles.heart_rate_axes);
        cla(handles.respiratory_rate_axes);
        legend(handles.monitoring_axes, 'hide');
        
        set(handles.file_record_txt, 'String', '');
        set(handles.heart_label, 'String', '');
        set(handles.respiratory_label, 'String', '');
        set(handles.delay_value, 'String', '');
        
        set(findall(handles.online_settings_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.fs_label, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.fs_txt, '-property', 'enable'), 'enable', 'on');
        
        set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.recordings_table, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_obs_txt, '-property', 'enable'), 'enable', 'off');
        
        set(findall(handles.load_pushbutton, '-property', 'enable'), 'enable', 'on');
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


% --- Executes on button press in hor_pan_radio.
function hor_pan_radio_Callback(hObject, eventdata, handles)
% hObject    handle to hor_pan_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hor_pan_radio
toggle_state = get(hObject,'Value');
if(toggle_state == 1),
%     disp('Enabling Horizontal pan...');
    pan(handles.monitoring_axes,'xon');
    pan(handles.heart_rate_axes,'xon');
    pan(handles.respiratory_rate_axes,'xon');
end


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

function [bytes,byte_counter] = read_serialport(serial_port)
if(isvalid(serial_port) && strcmp(serial_port.Status,'open') == 1),
    if(serial_port.BytesAvailable > 0),
        bytes_read = fread(serial_port,serial_port.BytesAvailable,'uint8');    
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

function timer_stop_callback(timerHandle,timerData)
timer_data = timerHandle.UserData;
handles = guidata(timer_data.hObject);

% Copy back handles values from timer handle
handles.training = timer_data.training;
handles.record_data = timer_data.record_data;
handles.filter_threshold = timer_data.filter_threshold ;
handles.ecg_analysis = timer_data.ecg_analysis;
handles.samples_processed_counter = timer_data.samples_processed_counter;
handles.HRs = timer_data.HRs;
handles.BRs = timer_data.BRs;
handles.Rts = timer_data.Rts;
handles.Pons = timer_data.Pons;
handles.Poffs = timer_data.Poffs;
handles.Qons = timer_data.Qons;
handles.Rpeaks = timer_data.Rpeaks;
handles.Soffs = timer_data.Soffs;
handles.Tons = timer_data.Tons;
handles.Toffs = timer_data.Toffs;
handles.start_index_for_analysis = timer_data.start_index_for_analysis;
handles.start_index_for_plotting = timer_data.start_index_for_plotting;
handles.current_hr = timer_data.current_hr;
handles.current_hr_step = timer_data.current_hr_step;
handles.current_hr_cum = timer_data.current_hr_cum;
handles.current_br = timer_data.current_br;
handles.current_br_step = timer_data.current_br_step;
handles.current_br_cum = timer_data.current_br_cum;
handles.heart32_icon = timer_data.heart32_icon;
handles.heart64_icon = timer_data.heart64_icon;
handles.lungs32_icon = timer_data.lungs32_icon;
handles.lungs64_icon = timer_data.lungs64_icon;
handles.delay_value = timer_data.delay_value;
handles.heart_label = timer_data.heart_label;
handles.respiratory_label = timer_data.respiratory_label;
handles.heart_pushbutton = timer_data.heart_pushbutton;
handles.respiratory_pushbutton = timer_data.respiratory_pushbutton;
handles.heart_rate_axes = timer_data.heart_rate_axes;
handles.respiratory_rate_axes = timer_data.respiratory_rate_axes;

% Close serial port
if(isvalid(handles.serial_port) && strcmp(handles.serial_port.Status,'open') == 1),
    fclose(handles.serial_port);
    delete(handles.serial_port);
%         msgbox('Successfully disconnected!','Successful disconnection to serial port','help');
end                   

data = handles.record_data; %#ok<NASGU>
save(handles.current_recording_path, 'data');

total_byte_count = numel(handles.record_data);
handles.recordings(handles.current_recording_index, :) ...
    = {handles.current_recording_name, sprintf('%d',total_byte_count), handles.current_recording_path};
set(handles.recordings_table, 'Data', handles.recordings);
drawnow;

msgbox(sprintf('Record %s saved!',handles.current_recording_path),'Successful recording','help');         

% Init monitoring_timer
handles.monitoring_timer = 0;

% Init serial port
handles.serial_port = 0;

% Init monitoring variables
% Selected row indices for recording and alarms tables.
handles.current_row_alarms_table = 0;
handles.current_row_recordings_table = 0;

% Init elapsed time
handles.elapsed_time = 0;

% Init ecg record
handles.record_data = [];

% Flag for training ECG recording
handles.training = 0;

% Time window for analysis
handles.time_window_for_analysis = 0;

% Training time in seconds
handles.training_time = 0;

% Time between samples.
handles.time_per_sample = 0;

% Number of samples per time window.
handles.number_of_samples_per_time_window = 0;

% Number of time windows for training
handles.number_of_time_windows_for_training = 0;

% Filter threshold
handles.filter_threshold = 0;

% Init ecg_analysis variables
handles.ecg_analysis = {};
handles.samples_processed_counter = 0;

% Heart rates
handles.HRs = [];

% Respiration rates
handles.BRs = [];

% Representative rate times
handles.Rts = [];

% Fiducial points for all the signal recording
handles.Pons = [];
handles.Poffs = [];
handles.Qons = [];
handles.Rpeaks = [];
handles.Soffs = [];
handles.Tons = [];
handles.Toffs = [];

% Start indexes for analysis and plotting
handles.start_index_for_analysis = 0;
handles.start_index_for_plotting = 0;        

set(handles.delay_value, 'String', '');
set(handles.heart_label, 'String', '#');
set(handles.respiratory_label, 'String', '#');

set(findall(handles.play_pushbutton, '-property', 'enable'), 'enable', 'on');
set(findall(handles.stop_pushbutton, '-property', 'enable'), 'enable', 'off');

guidata(timer_data.hObject, handles);
disp('timer_stop_callback!');

function timer_callback(timerHandle,timerData)
% Read handles
handles = timerHandle.UserData;
fprintf('Running timer callback at %s...\n',datestr(timerData.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF'));

% Read serial port
[bytes,byte_counter] = read_serialport(handles.serial_port);

if(byte_counter > 0),
    fprintf('record bytes = %d\n',numel(handles.record_data));

    % Compute start and end indexes.        
    start_index_for_plotting = numel(handles.record_data);        
    handles.record_data = [handles.record_data bytes];
    total_byte_count = numel(handles.record_data);    
    
    % Plot window limits 
    w_s = 500;
    w_e = 100;

    miny = min(handles.record_data);
    maxy = max(handles.record_data);

    start_i = 1;       

    for i = 1:10:byte_counter;
        h = handles.active_axes;

        cla(h);

        if(start_index_for_plotting+i > w_s),
            start_i = start_index_for_plotting+i-w_s;
        end

        end_i = start_index_for_plotting+i;

        plot(h, start_i:end_i, handles.record_data(start_i:end_i));
        plot(h, end_i, handles.record_data(end_i), 'or');

        xlim(h, [start_i,end_i+w_e]);
        ylim(h, [miny,maxy]);

        drawnow;
    end   

    if(handles.training == 1),
        training_window_size = handles.number_of_time_windows_for_training*handles.number_of_samples_per_time_window;
        if(total_byte_count >= training_window_size),
            % In the first phase of analysis, 'train' detector and reference time
            % windows. This aims for searching a reference R peak for further time
            % window detection. Always find a R peak as a reference for time window start.
            train_buffer = handles.record_data(1:training_window_size);

            % Initial filtering threshold for training
            desv_stand = 6.3593e+03;   % Initial standard deviation
            handles.filter_threshold = 300*desv_stand;             

            % Analyze train_buffer
            ecg_analysis_data = analyze_ecg_buffer(train_buffer, handles.fs, 1, handles.filter_threshold);

            % Save delays.
            ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);
            set(handles.delay_value, 'String', sprintf('%03.2f', ecg_analysis_data.delay/handles.fs));

            % Save data in ecg_analysis cell array
            handles.ecg_analysis(end+1) = {ecg_analysis_data};

            handles.samples_processed_counter = handles.samples_processed_counter + numel(train_buffer) - ecg_analysis_data.delay;
            handles.start_index_for_analysis = handles.samples_processed_counter + 1;                                

            % Save computed values
            % Heart rates                
            handles.HRs(end+1) = ecg_analysis_data.HR;                
            if(ecg_analysis_data.HR ~= Inf && ecg_analysis_data.HR ~= 0),
                handles.current_hr = ecg_analysis_data.HR;
                set(handles.heart_label, 'String', sprintf('%d', handles.current_hr));
            end                                

            % Respiration rates
            handles.BRs(end+1) = ecg_analysis_data.BR;
            if(ecg_analysis_data.BR ~= Inf && ecg_analysis_data.BR ~= 0),
                handles.current_br = ecg_analysis_data.BR;
                set(handles.respiratory_label, 'String', sprintf('%d', handles.current_br));
            end

            % Representative rate times
            handles.Rts(end+1) = ecg_analysis_data.reference_index + numel(ecg_analysis_data.filtered_buffer) - ecg_analysis_data.delay;

            % Fiducial points for all the signal recording
            handles.Pons = horzcat(handles.Pons, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Pons);
            handles.Poffs = horzcat(handles.Poffs, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Poffs);
            handles.Qons = horzcat(handles.Qons, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Qons);
            handles.Rpeaks = horzcat(handles.Rpeaks, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Rpeaks);
            handles.Soffs = horzcat(handles.Soffs, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Soffs);
            handles.Tons = horzcat(handles.Tons, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Tons);
            handles.Toffs = horzcat(handles.Toffs, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Toffs);

            handles.training = 0;
        end            
    else
        % Process ECG
        if(numel(handles.record_data) - handles.start_index_for_analysis >= handles.number_of_samples_per_time_window),
            analysis_buffer = handles.record_data(handles.start_index_for_analysis:handles.start_index_for_analysis+handles.number_of_samples_per_time_window);
            handles.filter_threshold = (0.99*handles.filter_threshold)+(0.01*(std(analysis_buffer)));                
            ecg_analysis_data = analyze_ecg_buffer(analysis_buffer, handles.fs, handles.start_index_for_analysis, handles.filter_threshold);
            ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);
            set(handles.delay_value, 'String', sprintf('%03.2f', ecg_analysis_data.delay/handles.fs));
            handles.ecg_analysis(end+1) = {ecg_analysis_data};
            handles.samples_processed_counter = handles.samples_processed_counter + numel(analysis_buffer) - ecg_analysis_data.delay;
            handles.start_index_for_analysis = handles.samples_processed_counter + 1;
            fprintf('Rpeaks found on %d samples = %d\n',numel(analysis_buffer),numel(ecg_analysis_data.fiducial_points.Rpeaks));
            fprintf('Estimated Heart Rate = %d and Respiratory Rate = %d\n',ecg_analysis_data.HR, ecg_analysis_data.BR);

            % Save computed values
            % Heart rates
            handles.HRs(end+1) = ecg_analysis_data.HR;                
            if(ecg_analysis_data.HR ~= Inf && ecg_analysis_data.HR ~= 0),
                handles.current_hr = ecg_analysis_data.HR;
                set(handles.heart_label, 'String', sprintf('%d', handles.current_hr));
            end

            % Respiration rates
            handles.BRs(end+1) = ecg_analysis_data.BR;
            if(ecg_analysis_data.BR ~= Inf && ecg_analysis_data.BR ~= 0),
                handles.current_br = ecg_analysis_data.BR;
                set(handles.respiratory_label, 'String', sprintf('%d', handles.current_br));
            end

            % Representative rate times
            handles.Rts(end+1) = ecg_analysis_data.reference_index + numel(ecg_analysis_data.filtered_buffer) - ecg_analysis_data.delay;

            % Fiducial points for all the signal recording
            handles.Pons = horzcat(handles.Pons, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Pons);
            handles.Poffs = horzcat(handles.Poffs, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Poffs);
            handles.Qons = horzcat(handles.Qons, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Qons);
            handles.Rpeaks = horzcat(handles.Rpeaks, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Rpeaks);
            handles.Soffs = horzcat(handles.Soffs, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Soffs);
            handles.Tons = horzcat(handles.Tons, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Tons);
            handles.Toffs = horzcat(handles.Toffs, ecg_analysis_data.reference_index+ecg_analysis_data.fiducial_points.Toffs);

            for x=1:1000,
                set(handles.heart_pushbutton,'CData',handles.heart32_icon);
                drawnow;     
            end
            set(handles.heart_pushbutton,'CData',handles.heart64_icon);
            drawnow;

            for x=1:1000,
                set(handles.respiratory_pushbutton,'CData',handles.lungs32_icon);
                drawnow;
            end
            set(handles.respiratory_pushbutton,'CData',handles.lungs64_icon);
            drawnow;
        end
    end                

    % Plot window limits
    r_s = 4;
    r_e = 500;
   
    cla(handles.heart_rate_axes);
    cla(handles.respiratory_rate_axes);

    start_index_for_rates = numel(handles.HRs);

    if(start_index_for_rates > 0),
        start_i = 1;

        if(start_index_for_rates > r_s),
            start_i = start_index_for_rates - r_s;
        end

        end_i = start_index_for_rates;

        plot(handles.heart_rate_axes, handles.Rts(start_i:end_i), handles.HRs(start_i:end_i));
        plot(handles.respiratory_rate_axes, handles.Rts(start_i:end_i), handles.BRs(start_i:end_i));

        xlim(handles.heart_rate_axes, [handles.Rts(start_i),handles.Rts(end_i)+r_e]);
        ylim(handles.heart_rate_axes, [0 max(handles.HRs(start_i:end_i))*1.5]);
        xlim(handles.respiratory_rate_axes, [handles.Rts(start_i),handles.Rts(end_i)+r_e]);
        ylim(handles.respiratory_rate_axes, [0 max(handles.BRs(start_i:end_i))*1.5]);

        drawnow;
    end        
end
timerHandle.UserData = handles;

% --- Executes on button press in play_pushbutton.
function play_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to play_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
handles.fs = str2double(get(handles.fs_txt,'String'));
guidata(hObject, handles);

if(isnan(handles.fs)),
    msgbox('Plese give a numeric value (decimal values separated by dot (.)) for sampling frequency Fs!','Error with sampling frequency','error');
    return;
end

handles.monitoring_timer = timer;
handles.monitoring_timer.StartDelay = 0;

% Reduce the speed in a factor of 10
handles.monitoring_timer.Period = 10/handles.fs;
handles.monitoring_timer.ExecutionMode = 'fixedRate';
handles.monitoring_timer.TimerFcn = @timer_callback;
handles.monitoring_timer.StopFcn = @timer_stop_callback;

timer_data = struct;        

grid(handles.monitoring_axes, 'off');
grid(handles.monitoring_axes, 'on');
grid(handles.monitoring_axes, 'minor');
hold(handles.monitoring_axes, 'on');

% Time window for analysis
handles.time_window_for_analysis = ceil(3000/handles.fs);    

% Training time in seconds
handles.training_time = 2*handles.time_window_for_analysis;    

% Time between samples.
handles.time_per_sample = 1/handles.fs;    

% Number of samples per time window.
handles.number_of_samples_per_time_window = floor(handles.time_window_for_analysis/handles.time_per_sample);    

% Number of time windows for training
handles.number_of_time_windows_for_training = floor(handles.training_time/handles.time_window_for_analysis);    

if(handles.training == 0),
    handles.training = 1;        
end

handles.current_recording_name = strrep(strrep(datestr(datetime('now')), ' ', '_'),':','_');

recording_path = strcat('recs/',handles.project_name);
if(~exist(recording_path, 'dir')),
    mkdir(recording_path);
end

handles.current_recording_path = strcat(recording_path,'/',handles.current_recording_name,'.mat');
handles.recordings(end+1,:) = {handles.current_recording_name, '0', handles.current_recording_path};
handles.current_recording_index = handles.current_recording_index + 1;
set(handles.recordings_table, 'Data', handles.recordings);
drawnow;

% Copy handles to timer handle
timer_data.fs = handles.fs;
timer_data.serial_port = handles.serial_port;
timer_data.active_axes = handles.monitoring_axes;
timer_data.inactive_axes = handles.hidden_axes;
timer_data.time_window_for_analysis = handles.time_window_for_analysis;
timer_data.training_time = handles.training_time;
timer_data.time_per_sample = handles.time_per_sample;
timer_data.number_of_samples_per_time_window = handles.number_of_samples_per_time_window;
timer_data.number_of_time_windows_for_training = handles.number_of_time_windows_for_training;
timer_data.training = handles.training;
timer_data.record_data = handles.record_data;
timer_data.filter_threshold = handles.filter_threshold ;
timer_data.ecg_analysis = handles.ecg_analysis;
timer_data.samples_processed_counter = handles.samples_processed_counter;
timer_data.HRs = handles.HRs;
timer_data.BRs = handles.BRs;
timer_data.Rts = handles.Rts;
timer_data.Pons = handles.Pons;
timer_data.Poffs = handles.Poffs;
timer_data.Qons = handles.Qons;
timer_data.Rpeaks = handles.Rpeaks;
timer_data.Soffs = handles.Soffs;
timer_data.Tons = handles.Tons;
timer_data.Toffs = handles.Toffs;
timer_data.start_index_for_analysis = handles.start_index_for_analysis;
timer_data.start_index_for_plotting = handles.start_index_for_plotting;
timer_data.current_hr = handles.current_hr;
timer_data.current_hr_step = handles.current_hr_step;
timer_data.current_hr_cum = handles.current_hr_cum;
timer_data.current_br = handles.current_br;
timer_data.current_br_step = handles.current_br_step;
timer_data.current_br_cum = handles.current_br_cum;
timer_data.heart32_icon = handles.heart32_icon;
timer_data.heart64_icon = handles.heart64_icon;
timer_data.lungs32_icon = handles.lungs32_icon;
timer_data.lungs64_icon = handles.lungs64_icon;
timer_data.delay_value = handles.delay_value;
timer_data.heart_label = handles.heart_label;
timer_data.respiratory_label = handles.respiratory_label;
timer_data.heart_pushbutton = handles.heart_pushbutton;
timer_data.respiratory_pushbutton = handles.respiratory_pushbutton;
timer_data.heart_rate_axes = handles.heart_rate_axes;
timer_data.respiratory_rate_axes = handles.respiratory_rate_axes;

timer_data.hObject = hObject;

handles.monitoring_timer.UserData = timer_data;

set(findall(handles.play_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.stop_pushbutton, '-property', 'enable'), 'enable', 'on');

guidata(hObject, handles);

start(handles.monitoring_timer);



% --- Executes on button press in stop_pushbutton.
function stop_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stop_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stop timer
stop(handles.monitoring_timer);
disp('Timer stop sent!');        

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

% Compute HRV params
h = waitbar(0,'Computing HRV parameters. Please wait...');

% Recordings and ECG Recording
if(get(handles.plot_type_axes,'Value') == 3 || get(handles.plot_type_axes,'Value') == 4),
    t = handles.ibi(:,1); %time (s)
    y = handles.ibi(:,2); %ibi (s)

    reset(handles.monitoring_axes);
    cla(handles.monitoring_axes);
    legend(handles.monitoring_axes, 'hide');

    grid(handles.monitoring_axes, 'off');
    grid(handles.monitoring_axes, 'on');
    grid(handles.monitoring_axes, 'minor');
    hold(handles.monitoring_axes, 'on');

    plot(handles.monitoring_axes, t, y);
    legend(handles.monitoring_axes, 'RR intervals diffs');
    set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'on');
end

handles.hrv_params = compute_hrv(handles.ibi);

% Update HRV tables
% Time measures
handles.time_table.Data = {'SDNN',sprintf('%0.4f',handles.hrv_params.SDNN);...
                           'SDANN',sprintf('%0.4f',handles.hrv_params.SDANN);...
                           'RMSSD',sprintf('%0.4f',handles.hrv_params.RMSSD);...
                           'SDSD',sprintf('%0.4f',handles.hrv_params.SDNNIDX);...
                           'pNN50',sprintf('%0.4f%%',100*handles.hrv_params.pNN50);};

% Frequency measures
handles.freq_table.Data = {'HF',sprintf('%0.4f',handles.hrv_params.aHF);...
                           'LF',sprintf('%0.4f',handles.hrv_params.aLF);...
                           'VLF',sprintf('%0.4f',handles.hrv_params.aVLF);...
                           'ULF',sprintf('%0.4f',handles.hrv_params.aULF);...
                           'LF/HF',sprintf('%0.4f',handles.hrv_params.rLFHF);};

set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'on');

close(h);
guidata(hObject, handles);

% --- Executes on button press in show_recording_pushbutton.
function show_recording_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to show_recording_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

if(handles.current_row_recordings_table ~= 0),
%     msgbox(sprintf('Showing recording # %d', handles.current_row_recordings_table), 'Info', 'help');    
    h = waitbar(0,'Processing recording. Please wait...');        

    recordings = handles.recordings_table.Data;
    recording_data = recordings(handles.current_row_recordings_table,:);
    
    set(handles.file_record_txt, 'String', recording_data{1});
    data_str = load(recording_data{3},'-mat','data');

    handles.current_load_data = data_str.data;
            
    % Time window for analysis
    handles.time_window_for_analysis = ceil(4000/handles.fs);

    % Time between samples.
    handles.time_per_sample = 1/handles.fs;

    % Number of samples per time window.
    handles.number_of_samples_per_time_window = floor(handles.time_window_for_analysis/handles.time_per_sample);   
    
    if(numel(handles.current_load_data)/handles.number_of_samples_per_time_window > 1),        
        reset(handles.monitoring_axes);
        cla(handles.monitoring_axes);
        cla(handles.heart_rate_axes);
        cla(handles.respiratory_rate_axes);
        legend(handles.monitoring_axes, 'hide');
        
        grid(handles.monitoring_axes, 'off');
        grid(handles.monitoring_axes, 'on');
        grid(handles.monitoring_axes, 'minor');
        hold(handles.monitoring_axes, 'on');
        
        % Initial filtering threshold for training
        desv_stand = 6.3593e+03;   % Initial standard deviation
        handles.filter_threshold = 300*desv_stand;

        handles.ecg_analysis = {};
        handles.samples_processed_counter = 0;
        
        start_index = handles.samples_processed_counter + 1;

        while(start_index+handles.number_of_samples_per_time_window < numel(handles.current_load_data)),
            analysis_buffer = handles.current_load_data(start_index:start_index+handles.number_of_samples_per_time_window);
            handles.filter_threshold = (0.99*handles.filter_threshold)+(0.01*(std(analysis_buffer)));
            ecg_analysis_data = analyze_ecg_buffer(analysis_buffer, handles.fs, start_index, handles.filter_threshold);
            ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);
            handles.ecg_analysis(end+1) = {ecg_analysis_data};
            handles.samples_processed_counter = handles.samples_processed_counter + numel(analysis_buffer) - ecg_analysis_data.delay;
            start_index = handles.samples_processed_counter + 1;
            fprintf('Rpeaks found on %d samples = %d\n',numel(analysis_buffer),numel(ecg_analysis_data.fiducial_points.Rpeaks));
            fprintf('Estimated Heart Rate = %d and Respiratory Rate = %d\n',ecg_analysis_data.HR, ecg_analysis_data.BR);
        end

        % Totalize ECG analysis
        analysis_count = numel(handles.ecg_analysis);

        fprintf('ecg_analysis length = %d\n', analysis_count);
        fprintf('final delay = %d\n', ecg_analysis_data.delay);
        fprintf('time_window_for_analysis = %d segs\n',handles.time_window_for_analysis);

        % Heart rates
        handles.HRs = zeros(1, analysis_count);

        % Respiration rates
        handles.BRs = zeros(1, analysis_count);

        % Representative rate times
        handles.Rts = zeros(1, analysis_count);

        % Fiducial points for all the signal recording
        handles.Pons = [];
        handles.Poffs = [];
        handles.Qons = [];
        handles.Rpeaks = [];
        handles.Soffs = [];
        handles.Tons = [];
        handles.Toffs = [];

        % Read estimated heart and respiratory rates with their respective times.
        % Associated times for rates are computed as reference_index +
        % filtered_buffer size - delay.
        for i=1:analysis_count,
            handles.HRs(i) = handles.ecg_analysis{i}.HR;    
            handles.BRs(i) = handles.ecg_analysis{i}.BR;
            handles.Rts(i) = handles.ecg_analysis{i}.reference_index + numel(handles.ecg_analysis{i}.filtered_buffer) - handles.ecg_analysis{i}.delay;

            handles.Pons = horzcat(handles.Pons, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Pons);
            handles.Poffs = horzcat(handles.Poffs, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Poffs);
            handles.Qons = horzcat(handles.Qons, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Qons);
            handles.Rpeaks = horzcat(handles.Rpeaks, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Rpeaks);
            handles.Soffs = horzcat(handles.Soffs, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Soffs);
            handles.Tons = horzcat(handles.Tons, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Tons);
            handles.Toffs = horzcat(handles.Toffs, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Toffs);
        end

        % Save ibi for HRV analysis.
        inter = diff(handles.Rpeaks);
        times = inter/handles.fs;
        handles.ibi = zeros(numel(times), 2);

        handles.ibi(1,1) = 0;
        handles.ibi(:,2) = times;

        for j=1:numel(times)-1,
            handles.ibi(j+1,1) = handles.ibi(j,2) + handles.ibi(j,1);
        end           
        
        % Plot signal.
        t = 1/handles.fs:1/handles.fs:numel(handles.current_load_data)/handles.fs;
        plot(handles.monitoring_axes, t, handles.current_load_data);
        legend(handles.monitoring_axes, 'ECG recording');
        xlim(handles.monitoring_axes, [t(1) t(end)]);
        ylim(handles.monitoring_axes, [min(handles.current_load_data) max(handles.current_load_data)]);

        % Plot heart and respiratory rate
        plot(handles.heart_rate_axes, handles.Rts, handles.HRs);
        plot(handles.respiratory_rate_axes, handles.Rts, handles.BRs);
        xlim(handles.heart_rate_axes, [handles.Rts(1) handles.Rts(end)]);
        xlim(handles.respiratory_rate_axes, [handles.Rts(1) handles.Rts(end)]);

        % Show mean values for HR, BR and delay
        set(handles.heart_label, 'String', sprintf('%.2f', mean(handles.HRs((handles.HRs ~= 0) &(handles.HRs ~= Inf)))));
        set(handles.respiratory_label, 'String', sprintf('%.2f', mean(handles.BRs((handles.BRs ~= 0) &(handles.BRs ~= Inf)))));
        set(handles.delay_value, 'String', sprintf('%03.2f', handles.ecg_analysis{end}.delay/handles.fs));                
        
        ylim(handles.heart_rate_axes, [0 max(handles.HRs)*1.5]);
        ylim(handles.respiratory_rate_axes, [0 max(handles.BRs)*1.5]);

        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'on');        
    else
        reset(handles.monitoring_axes);
        cla(handles.monitoring_axes);
        cla(handles.heart_rate_axes);
        cla(handles.respiratory_rate_axes);
        legend(handles.monitoring_axes, 'hide');
        
        grid(handles.monitoring_axes, 'off');
        grid(handles.monitoring_axes, 'on');
        grid(handles.monitoring_axes, 'minor');
        hold(handles.monitoring_axes, 'on');
        
        set(handles.heart_label, 'String', '');
        set(handles.respiratory_label, 'String', '');
        set(handles.delay_value, 'String', '');
        
        set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hrv_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');                
        set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'on');
        
        % Plot signal.
        t = 1/handles.fs:1/handles.fs:numel(handles.current_load_data)/handles.fs;
        plot(handles.monitoring_axes, t, handles.current_load_data);
        legend(handles.monitoring_axes, 'ECG recording');
        xlim(handles.monitoring_axes, [t(1) t(end)]);
        ylim(handles.monitoring_axes, [min(handles.current_load_data) max(handles.current_load_data)]);
        
        msgbox(sprintf('Cannot perform ECG analysis. Recording should have a minimum lenght of %d samples (4 seconds) for sampling frequency %d. Only displaying recording.', handles.number_of_samples_per_time_window, handles.fs), 'Cannot perform ECG analysis','warn');
    end          
    close(h);
else
%     msgbox(sprintf('No recording to show!'), 'Info', 'help');
end
guidata(hObject, handles);


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
handles = guidata(hObject);

handles.fs = str2double(get(handles.fs_txt,'String'));
guidata(hObject, handles);

if(isnan(handles.fs)),
    msgbox('Plese give a numeric value (decimal values separated by dot (.)) for sampling frequency Fs!','Error with sampling frequency','error');
    return;
end

[FileName,PathName] = uigetfile('db/*.mat','Please select a record file...');

if(FileName ~= 0),
    handles.file_record_name = FileName;
    handles.file_record_path = PathName;
    set(handles.file_record_txt, 'String', handles.file_record_name);
    data_str = load(strcat(PathName,FileName),'-mat','data');

    if(~isstruct(data_str) || ~isfield(data_str, 'data')),
        msgbox('Please provide a valid .mat file with record saved in data variable!','Error loading record file.','error');
        return;
    end

    handles.current_load_data = data_str.data;

    switch get(handles.plot_type_axes,'Value')
        case 1 % HRV
            h = waitbar(0,'Processing HRV record. Please wait...');
            inter = diff(handles.current_load_data);
            times = inter/handles.fs;
            handles.ibi = zeros(numel(times), 2);

            handles.ibi(1,1) = 0;
            handles.ibi(:,2) = times;

            for j=1:numel(times)-1,
                handles.ibi(j+1,1) = handles.ibi(j,2) + handles.ibi(j,1);
            end           

            t = handles.ibi(:,1); %time (s)
            y = handles.ibi(:,2); %ibi (s)
            
            reset(handles.monitoring_axes);
            cla(handles.monitoring_axes);
            cla(handles.heart_rate_axes);
            cla(handles.respiratory_rate_axes);
            legend(handles.monitoring_axes, 'hide');
            
            grid(handles.monitoring_axes, 'off');
            grid(handles.monitoring_axes, 'on');
            grid(handles.monitoring_axes, 'minor');
            hold(handles.monitoring_axes, 'on');
        
            plot(handles.monitoring_axes, t, y);     
            legend(handles.monitoring_axes, 'RR interval diffs');
            set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'on');
            close(h);
        otherwise % ECG Record
            h = waitbar(0,'Processing ECG record. Please wait...');
            
            % Time window for analysis
            handles.time_window_for_analysis = ceil(4000/handles.fs);

            % Training time in seconds
            handles.training_time = 2*handles.time_window_for_analysis;

            % Time between samples.
            handles.time_per_sample = 1/handles.fs;

            % Number of samples per time window.
            handles.number_of_samples_per_time_window = floor(handles.time_window_for_analysis/handles.time_per_sample);

            % Number of time windows for training
            handles.number_of_time_windows_for_training = floor(handles.training_time/handles.time_window_for_analysis);

            % Perform a sliding window analysis over ECG signal.

            % In the first phase of analysis, 'train' detector and reference time
            % windows. This aims for searching a reference R peak for further time
            % window detection. Always find a R peak as a reference for time window start.
            train_buffer = handles.current_load_data(1:handles.number_of_time_windows_for_training*handles.number_of_samples_per_time_window);

            % Initial filtering threshold for training
            desv_stand = 6.3593e+03;   % Initial standard deviation
            handles.filter_threshold = 300*desv_stand;

            handles.ecg_analysis = {};
            handles.samples_processed_counter = 0;

            % Analyze train_buffer
            ecg_analysis_data = analyze_ecg_buffer(train_buffer, handles.fs, 1, handles.filter_threshold);

            % Save delays.
            ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);

            % Save data in ecg_analysis cell array
            handles.ecg_analysis(end+1) = {ecg_analysis_data};

            handles.samples_processed_counter = handles.samples_processed_counter + numel(train_buffer) - ecg_analysis_data.delay;
            start_index = handles.samples_processed_counter + 1;

            while(start_index+handles.number_of_samples_per_time_window < numel(handles.current_load_data)),
                analysis_buffer = handles.current_load_data(start_index:start_index+handles.number_of_samples_per_time_window);
                handles.filter_threshold = (0.99*handles.filter_threshold)+(0.01*(std(analysis_buffer)));
                ecg_analysis_data = analyze_ecg_buffer(analysis_buffer, handles.fs, start_index, handles.filter_threshold);
                ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);
                handles.ecg_analysis(end+1) = {ecg_analysis_data};
                handles.samples_processed_counter = handles.samples_processed_counter + numel(analysis_buffer) - ecg_analysis_data.delay;
                start_index = handles.samples_processed_counter + 1;
                fprintf('Rpeaks found on %d samples = %d\n',numel(analysis_buffer),numel(ecg_analysis_data.fiducial_points.Rpeaks));
                fprintf('Estimated Heart Rate = %d and Respiratory Rate = %d\n',ecg_analysis_data.HR, ecg_analysis_data.BR);
            end

            % Totalize ECG analysis
            analysis_count = numel(handles.ecg_analysis);

            fprintf('ecg_analysis length = %d\n', analysis_count);
            fprintf('final delay = %d\n', ecg_analysis_data.delay);
            fprintf('time_window_for_analysis = %d segs\n',handles.time_window_for_analysis);

            % Heart rates
            handles.HRs = zeros(1, analysis_count);

            % Respiration rates
            handles.BRs = zeros(1, analysis_count);

            % Representative rate times
            handles.Rts = zeros(1, analysis_count);

            % Fiducial points for all the signal recording
            handles.Pons = [];
            handles.Poffs = [];
            handles.Qons = [];
            handles.Rpeaks = [];
            handles.Soffs = [];
            handles.Tons = [];
            handles.Toffs = [];

            % Read estimated heart and respiratory rates with their respective times.
            % Associated times for rates are computed as reference_index +
            % filtered_buffer size - delay.
            for i=1:analysis_count,
                handles.HRs(i) = handles.ecg_analysis{i}.HR;    
                handles.BRs(i) = handles.ecg_analysis{i}.BR;
                handles.Rts(i) = handles.ecg_analysis{i}.reference_index + numel(handles.ecg_analysis{i}.filtered_buffer) - handles.ecg_analysis{i}.delay;

                handles.Pons = horzcat(handles.Pons, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Pons);
                handles.Poffs = horzcat(handles.Poffs, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Poffs);
                handles.Qons = horzcat(handles.Qons, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Qons);
                handles.Rpeaks = horzcat(handles.Rpeaks, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Rpeaks);
                handles.Soffs = horzcat(handles.Soffs, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Soffs);
                handles.Tons = horzcat(handles.Tons, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Tons);
                handles.Toffs = horzcat(handles.Toffs, handles.ecg_analysis{i}.reference_index+handles.ecg_analysis{i}.fiducial_points.Toffs);
            end
            
            % Save ibi for HRV analysis.
            inter = diff(handles.Rpeaks);
            times = inter/handles.fs;
            handles.ibi = zeros(numel(times), 2);

            handles.ibi(1,1) = 0;
            handles.ibi(:,2) = times;

            for j=1:numel(times)-1,
                handles.ibi(j+1,1) = handles.ibi(j,2) + handles.ibi(j,1);
            end           
            
            reset(handles.monitoring_axes);
            cla(handles.monitoring_axes);
            cla(handles.heart_rate_axes);
            cla(handles.respiratory_rate_axes);
            legend(handles.monitoring_axes, 'hide');
            
            grid(handles.monitoring_axes, 'off');
            grid(handles.monitoring_axes, 'on');
            grid(handles.monitoring_axes, 'minor');
            hold(handles.monitoring_axes, 'on');
            
            % Plot signal.
            t = 1/handles.fs:1/handles.fs:numel(handles.current_load_data)/handles.fs;
            plot(handles.monitoring_axes, t, handles.current_load_data);
            legend(handles.monitoring_axes, 'ECG record');
            
            % Plot heart and respiratory rate
            plot(handles.heart_rate_axes, handles.Rts, handles.HRs);
            plot(handles.respiratory_rate_axes, handles.Rts, handles.BRs);
            
            % Show mean values for HR, BR and delay
            set(handles.heart_label, 'String', sprintf('%.2f', mean(handles.HRs((handles.HRs ~= 0) &(handles.HRs ~= Inf)))));
            set(handles.respiratory_label, 'String', sprintf('%.2f', mean(handles.BRs((handles.BRs ~= 0) &(handles.BRs ~= Inf)))));
            set(handles.delay_value, 'String', sprintf('%03.2f', handles.ecg_analysis{end}.delay/handles.fs));
            
            ylim(handles.heart_rate_axes, [0 max(handles.HRs)*1.5]);
            ylim(handles.respiratory_rate_axes, [0 max(handles.BRs)*1.5]);
            
            set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.heart_respiratory_panel, '-property', 'enable'), 'enable', 'on');
            
            set(findall(handles.plot_options_group, '-property', 'enable'), 'enable', 'on');
                                    
            close(h);
    end
end
guidata(hObject, handles);


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

% fprintf('Current row selected on recordings table:');
disp(eventdata.Indices(1));
handles.current_row_recordings_table = eventdata.Indices(1);

set(findall(handles.show_fiducial_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.check_alarms_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.compute_hrv_pushbutton, '-property', 'enable'), 'enable', 'off');
set(findall(handles.show_recording_pushbutton, '-property', 'enable'), 'enable', 'on');

guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in alarms_table.
function alarms_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to alarms_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close easych_figure.
function easych_figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to easych_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

% Close and delete serial port if present
if(handles.serial_port ~= 0),
    if(isvalid(handles.serial_port) && strcmp(handles.serial_port.Status,'open') == 1),
        fclose(handles.serial_port);
        delete(handles.serial_port);
    end
end

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in hor_zoom_radio.
function hor_zoom_radio_Callback(hObject, eventdata, handles)
% hObject    handle to hor_zoom_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hor_zoom_radio
toggle_state = get(hObject,'Value');
if(toggle_state == 1),
    zoom(handles.monitoring_axes,'xon');
    zoom(handles.heart_rate_axes,'xon');
    zoom(handles.respiratory_rate_axes,'xon');
end


% --- Executes on button press in no_zoom_radio.
function no_zoom_radio_Callback(hObject, eventdata, handles)
% hObject    handle to no_zoom_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of no_zoom_radio
toggle_state = get(hObject,'Value');
if(toggle_state == 1),
    zoom(handles.monitoring_axes,'off');
    zoom(handles.heart_rate_axes,'off');
    zoom(handles.respiratory_rate_axes,'off');
end


% --- Executes on button press in free_zoom_radio.
function free_zoom_radio_Callback(hObject, eventdata, handles)
% hObject    handle to free_zoom_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of free_zoom_radio
toggle_state = get(hObject,'Value');
if(toggle_state == 1),
    zoom(handles.monitoring_axes,'on');
    zoom(handles.heart_rate_axes,'on');
    zoom(handles.respiratory_rate_axes,'on');
end


% --- Executes on button press in check_alarms_pushbutton.
function check_alarms_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to check_alarms_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[alarms_exist,alarms_generated] = alarms_module(handles.BRs,handles.HRs,handles.fs,handles.Tons,handles.Toffs,handles.Qons,handles.Rpeaks,handles.Soffs,handles.current_load_data);

if(alarms_exist == 1),
    set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'on');
    
    switch get(handles.plot_type_axes,'Value')
        case 1 % HRV Record       
            set(findall(handles.alarms_obs_txt, '-property', 'enable'), 'enable', 'off');
        case 2 % Online        
            set(findall(handles.alarms_obs_txt, '-property', 'enable'), 'enable', 'off');                
        case 3 % Recordings       
            set(findall(handles.alarms_obs_txt, '-property', 'enable'), 'enable', 'on');        
        otherwise % ECG Record        
            set(findall(handles.alarms_obs_txt, '-property', 'enable'), 'enable', 'off');                
    end

    msgbox('Warning. Some alarms where generated... Take recording and send it to your Physician for reviewing with EasyCH.','Alarms generated','warn');
    
    handles.alarms = {};
    
    for i=1:numel(alarms_generated),
        if(alarms_generated(i) == 1),
            handles.alarms(end+1,:) = {handles.alarms_names{i} handles.alarms_descriptions{i}};
        end
    end
    handles.alarms_table.Data = handles.alarms;
    drawnow;
else
    set(findall(handles.alarms_panel, '-property', 'enable'), 'enable', 'off');
    msgbox('No alarms generated!','No alarms','help');
end


% --- Executes on button press in show_fiducial_pushbutton.
function show_fiducial_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to show_fiducial_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = waitbar(0,'Computing fiducial points. Please wait...');

reset(handles.monitoring_axes);
cla(handles.monitoring_axes);
legend(handles.monitoring_axes, 'hide');

% Plot signal.
t = 1/handles.fs:1/handles.fs:numel(handles.current_load_data)/handles.fs;
plot(handles.monitoring_axes, t, handles.current_load_data);

hold(handles.monitoring_axes, 'on');
plot(handles.monitoring_axes, t(round(handles.Pons)),handles.current_load_data(round(handles.Pons)),'k^','markerfacecolor',[0 1 0],'markersize',12);
hold(handles.monitoring_axes, 'on');
plot(handles.monitoring_axes, t(round(handles.Poffs)),handles.current_load_data(round(handles.Poffs)),'k^','markerfacecolor',[0 1 1],'markersize',12);
hold(handles.monitoring_axes, 'on');
plot(handles.monitoring_axes, t(round(handles.Qons)),handles.current_load_data(round(handles.Qons)),'k^','markerfacecolor',[1 1 0],'markersize',12);
hold(handles.monitoring_axes, 'on');
plot(handles.monitoring_axes, t(round(handles.Rpeaks)),handles.current_load_data(round(handles.Rpeaks)),'k^','markerfacecolor',[1 0 0],'markersize',12);
hold(handles.monitoring_axes, 'on');
plot(handles.monitoring_axes, t(round(handles.Soffs)),handles.current_load_data(round(handles.Soffs)),'k^','markerfacecolor',[1 0 1],'markersize',12);
hold(handles.monitoring_axes, 'on');
plot(handles.monitoring_axes, t(round(handles.Tons)),handles.current_load_data(round(handles.Tons)),'k^','markerfacecolor',[1 1 1],'markersize',12);
hold(handles.monitoring_axes, 'on');
plot(handles.monitoring_axes, t(round(handles.Toffs)),handles.current_load_data(round(handles.Toffs)),'k^','markerfacecolor',[0 0 0],'markersize',12);
hold(handles.monitoring_axes, 'on');

legend(handles.monitoring_axes, 'ECG signal','Pon','Poff','Qon','Rpeak','Soff','Ton','Toff');

close(h);


% --- Executes on button press in data_cursor_radio.
function data_cursor_radio_Callback(hObject, eventdata, handles)
% hObject    handle to data_cursor_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data_cursor_radio
toggle_state = get(hObject,'Value');
if(toggle_state == 1),
    datacursormode(handles.easych_figure,'on');
end
