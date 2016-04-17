function [record_resampled_y,real_desired_fs] = load_synthetic_ecg_record( desired_fs )
%LOAD_SYNTHETIC_ECG_RECORD Loads a synthetic ECG signal.
%   Load into record_resample_y with desired_fs sampling frequency a
%   synthetic ECG signal.

if ~(exist('ECGdata','var')),
    senal = load('db/ECGdata.mat');
end

ecg = senal.ECGdata(:,1);
fs = 250;

final_index = numel(ecg);

x = 1/fs:1/fs:final_index/fs;

% Desired resample percentage
real_desired_fs_p = desired_fs/fs;
real_desired_fs = round(real_desired_fs_p*fs);

y = ecg;

real_resample_count = floor((x(end)-x(1))/real_desired_fs);

record_resampled_y = zeros(1, real_resample_count);
record_resampled = 0;

last_resampled_index = 0;

% Resample ECG record with desired sampling fs
for i=1:numel(y),
    if( i - last_resampled_index >= 1/real_desired_fs_p ),
        record_resampled = record_resampled + 1;
        last_resampled_index = i;
        record_resampled_y(record_resampled) = y(i);
    end
end

end