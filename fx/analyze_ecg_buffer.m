function [ ecg_analysis_data ] = analyze_ecg_buffer( buffer, fs , reference_index, filter_threshold )
%ANALYZE_ECG_BUFFER Analyze ECG signal buffer.
%   Given a signal buffer with sampling frequency fs, find:
%       1. Fiducial points: Pons, Poffs, Qon, Rpeaks, Soff, Tons, Toffs
%       2. Estimated heart rate: HR
%       3. Estimated respiratory rate: BR

% Preprocess ECG. Filtering.
filtered_buffer = filter_ecg(buffer, filter_threshold);

% Perform ECG delineation, find fiducial points.
[fiducial_points,last_r_peak] = delineate_ecg(filtered_buffer,fs);

% Adjust Rpeaks to fix local maxima miss-search
[fiducial_points.Rpeak,last_r_peak] = adjust_r_peaks(fiducial_points.Rpeak,filtered_buffer,fs,last_r_peak);

% Realizar estimacion de frecuencia cardiaca
HR = estimate_heart_rate(fiducial_points.Rpeak,filtered_buffer,fs);

% Realizar estimacion de frecuencia respiratoria utilizando
% distancias entre picos R.
BR = estimate_respiratory_rate(fiducial_points,filtered_buffer,fs,'RS');

% Initialize ecg_analysis_data as struct
ecg_analysis_data = struct;

% Save reference_index.
ecg_analysis_data.reference_index = reference_index;

% Init fiducial_points struct.
ecg_analysis_data.fiducial_points = struct;

% Save fiducial_points.
ecg_analysis_data.fiducial_points.Pons = fiducial_points.Pon;
ecg_analysis_data.fiducial_points.Poffs = fiducial_points.Poff;
ecg_analysis_data.fiducial_points.Qons = fiducial_points.Qon;
ecg_analysis_data.fiducial_points.Rpeaks = fiducial_points.Rpeak;
ecg_analysis_data.fiducial_points.Soffs = fiducial_points.Soff;
ecg_analysis_data.fiducial_points.Tons = fiducial_points.Ton;
ecg_analysis_data.fiducial_points.Toffs = fiducial_points.Toff;

% Save estimated heart rate.
ecg_analysis_data.HR = HR;

% Save estimated respiratory rate.
ecg_analysis_data.BR = BR;

% Save filtered buffer.
ecg_analysis_data.filtered_buffer = filtered_buffer;

% Save last R peak.
ecg_analysis_data.last_r_peak = last_r_peak;

end