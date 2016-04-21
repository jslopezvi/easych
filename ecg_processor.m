addpath('sim');

% [signal, fs] = load_synthetic_ecg_record(250);
[signal, fs] = load_mitbih_arrhythmia_record('rec101',360);

% Time window for analysis
time_window_for_analysis = ceil(4000/fs);

% Training time in seconds
training_time = 2*time_window_for_analysis;

% Time between samples.
time_per_sample = 1/fs;

% Number of samples per time window.
number_of_samples_per_time_window = floor(time_window_for_analysis/time_per_sample);

% Number of time windows for training
number_of_time_windows_for_training = floor(training_time/time_window_for_analysis);

% Perform a sliding window analysis over ECG signal.

% In the first phase of analysis, 'train' detector and reference time
% windows. This aims for searching a reference R peak for further time
% window detection. Always find a R peak as a reference for time window start.
train_buffer = signal(1:number_of_time_windows_for_training*number_of_samples_per_time_window);

% Initial filtering threshold for training
desv_stand = 6.3593e+03;   % Initial standard deviation
filter_threshold = 300*desv_stand;

ecg_analysis = {};
samples_processed_counter = 0;

% Analyze train_buffer
ecg_analysis_data = analyze_ecg_buffer(train_buffer, fs, 1, filter_threshold);

% Save delays.
ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);

% Save data in ecg_analysis cell array
ecg_analysis(end+1) = {ecg_analysis_data};

samples_processed_counter = samples_processed_counter + numel(train_buffer) - ecg_analysis_data.delay;
start_index = samples_processed_counter + 1;

while(start_index+number_of_samples_per_time_window < numel(signal)),
    analysis_buffer = signal(start_index:start_index+number_of_samples_per_time_window);
    filter_threshold = (0.99*filter_threshold)+(0.01*(std(analysis_buffer)));
    ecg_analysis_data = analyze_ecg_buffer(analysis_buffer, fs, start_index, filter_threshold);
    ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);
    ecg_analysis(end+1) = {ecg_analysis_data}; %#ok<SAGROW>
    samples_processed_counter = samples_processed_counter + numel(analysis_buffer) - ecg_analysis_data.delay;
    start_index = samples_processed_counter + 1;
    fprintf('Rpeaks found on %d samples = %d\n',numel(analysis_buffer),numel(ecg_analysis_data.fiducial_points.Rpeaks));
    fprintf('Estimated Heart Rate = %d and Respiratory Rate = %d\n',ecg_analysis_data.HR, ecg_analysis_data.BR);
end

% Totalize ECG analysis
analysis_count = numel(ecg_analysis);

fprintf('ecg_analysis length = %d\n', analysis_count);
fprintf('final delay = %d\n', ecg_analysis_data.delay);
fprintf('time_window_for_analysis = %d segs\n',time_window_for_analysis);

% Heart rates
HRs = zeros(1, analysis_count);

% Respiration rates
BRs = zeros(1, analysis_count);

% Representative rate times
Rts = zeros(1, analysis_count);

% Fiducial points for all the signal recording
Pons = [];
Poffs = [];
Qons = [];
Rpeaks = [];
Soffs = [];
Tons = [];
Toffs = [];

% Read estimated heart and respiratory rates with their respective times.
% Associated times for rates are computed as reference_index +
% filtered_buffer size - delay.
for i=1:analysis_count,
    HRs(i) = ecg_analysis{i}.HR;
    BRs(i) = ecg_analysis{i}.BR;
    Rts(i) = ecg_analysis{i}.reference_index + numel(ecg_analysis{i}.filtered_buffer) - ecg_analysis{i}.delay;
    
    Pons = horzcat(Pons, ecg_analysis{i}.fiducial_points.Pons); %#ok<AGROW>
    Poffs = horzcat(Poffs, ecg_analysis{i}.fiducial_points.Poffs); %#ok<AGROW>
    Qons = horzcat(Qons, ecg_analysis{i}.fiducial_points.Qons); %#ok<AGROW>
    Rpeaks = horzcat(Rpeaks, ecg_analysis{i}.fiducial_points.Rpeaks); %#ok<AGROW>
    Soffs = horzcat(Soffs, ecg_analysis{i}.fiducial_points.Soffs); %#ok<AGROW>
    Tons = horzcat(Tons, ecg_analysis{i}.fiducial_points.Tons); %#ok<AGROW>
    Toffs = horzcat(Toffs, ecg_analysis{i}.fiducial_points.Toffs); %#ok<AGROW>
end

plot(Rts, HRs,'b');
hold on;
plot(Rts, BRs,'r');
legend('Heart Rate','Respiratory Rate');

[Exist,Type] = alarms_module(BRs,HRs,fs,Tons,Toffs,Qons,Rpeaks,Soffs,signal);

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

alarms_names = {type1; type2; type3; type4; type5; type6; type7; type8};
alarms_descriptions = {type1_desc; type2_desc; type3_desc; type4_desc; type5_desc; type6_desc; type7_desc; type8_desc};

if(Exist == 1),
    fprintf('Warning. Some alarms where generated... Take recording and send it to your Physician for reviewing with EasyCH.\n');
    
    fprintf('The following alarms were generated for this recording:\n');
    for i=1:numel(Type),
        if(Type(i) == 1),
            fprintf('\t%s - %s\n',alarms_names{i},alarms_descriptions{i});
        end
    end
else
    fprintf('No alarms generated!\n');
end