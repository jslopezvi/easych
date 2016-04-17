addpath('sim');

% [signal, fs] = load_synthetic_ecg_record(250);
[signal, fs] = load_mitbih_arrhythmia_record('rec101',360);

% Time window for analysis of 300ms.
time_window_for_analysis = 0.8;

% Training time in seconds
training_time = 5;

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

% Analyze train_buffer
ecg_analysis_data = analyze_ecg_buffer(train_buffer, fs, 1, filter_threshold);

% Save data in ecg_analysis cell array
ecg_analysis(end+1) = {ecg_analysis_data};

% Init delays struct.
ecg_analysis_data.delays = struct;

% Save delays.
ecg_analysis_data.delays.start = min(ecg_analysis_data.fiducial_points.Pons);
ecg_analysis_data.delays.end = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);

start_index = numel(train_buffer) - ecg_analysis_data.delays.end;

analysis_buffer = signal(start_index:start_index+number_of_samples_per_time_window);
ecg_analysis_data.filter_threshold = (0.99*ecg_analysis_data.filter_threshold)+(0.01*(std(buffer)));
ecg_analysis_data = analyze_ecg_buffer(train_buffer, fs, 1, ecg_analysis_data.filter_threshold);

for i=1:number_of_time_windows_for_training,
    for j=1:number_of_samples_per_time_window,
        train_sample_counter = train_sample_counter + 1;
        train_buffer(train_sample_counter) = signal(start_index+train_sample_counter-1);
    end
end







