function [record_resampled_y,real_desired_fs] = load_mitbih_arrhythmia_record( record_name, desired_fs )
%LOAD_MITBIH_ARRHYTHMIA_RECORD Load a MIT-BIH Arrhythmia ECG record.
%   Given a desired sampling frequency, resample the record name specified.

if ~(exist('MITBD','var')),
    load db/MITDB.mat
end

if ~(isfield(MITDB,record_name)),
    fprintf('Error reading MIT-BIH database: uknown record %s!\n', record_name);
    return;
end

ecg = MITDB.(record_name).ecg;
fs = MITDB.(record_name).hea.freq;
final_index = numel(ecg);

x = 1/fs:1/fs:final_index/fs;

% Desired resample percentage
real_desired_fs_p = desired_fs/fs;
real_desired_fs = round(real_desired_fs_p*fs);

resample_x = 1/fs:1/real_desired_fs:numel(x)/fs;
    
y = ecg;

record_resampled_y = zeros(1, numel(resample_x));
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