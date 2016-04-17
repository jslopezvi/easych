addpath('sim');

% [signal, fs] = load_synthetic_ecg_record(250);
[signal, fs] = load_mitbih_arrhythmia_record('rec101',360);

% Time window for analysis
time_window_for_analysis = ceil(1000/fs);

% Training time in seconds
training_time = 3*time_window_for_analysis;

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

% Save data in ecg_analysis cell array
ecg_analysis(end+1) = {ecg_analysis_data};

% Save delays.
ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);

samples_processed_counter = samples_processed_counter + numel(train_buffer) - ecg_analysis_data.delay;
start_index = samples_processed_counter + 1;

while(start_index+number_of_samples_per_time_window < numel(signal)),
    analysis_buffer = signal(start_index:start_index+number_of_samples_per_time_window);
    ecg_analysis_data.filter_threshold = (0.99*ecg_analysis_data.filter_threshold)+(0.01*(std(analysis_buffer)));
    ecg_analysis_data = analyze_ecg_buffer(analysis_buffer, fs, start_index, ecg_analysis_data.filter_threshold);
    ecg_analysis_data.delay = numel(ecg_analysis_data.filtered_buffer) - max(ecg_analysis_data.fiducial_points.Toffs);
    ecg_analysis(end+1) = {ecg_analysis_data}; %#ok<SAGROW>
    samples_processed_counter = samples_processed_counter + numel(analysis_buffer) - ecg_analysis_data.delay;
    start_index = samples_processed_counter + 1;
end

fprintf('ecg_analysis length = %d\n', numel(ecg_analysis));
fprintf('final delay = %d\n', ecg_analysis_data.delay);