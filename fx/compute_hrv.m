function [ hrv_params ] = compute_hrv( ibi )
%COMPUTE_HRV Summary of this function goes here
%   Detailed explanation goes here

t = ibi(:,1); %time (s)
y = ibi(:,2); %ibi (s)     
dy = diff(y);

% Time domain HRV measures        
hrv_params.AVNN = mean(y);
hrv_params.SDNN = std(y);

% Five minutes  in seconds
m5 = 5*60;    
number_of_m5_segments = floor(max(t)/m5);
m5_segments_means = zeros(1,number_of_m5_segments);
m5_segments_stds = zeros(1,number_of_m5_segments);

for k=1:number_of_m5_segments,
    start_i = (k-1)*m5;
    end_i = k*m5;
    m5_t_indexes = find((t>=start_i) & (t<end_i));
    m5_segments_means(k) = mean(y(m5_t_indexes));
    m5_segments_stds(k) = std(y(m5_t_indexes));
end

hrv_params.SDANN = std(m5_segments_means);
hrv_params.SDNNIDX = mean(m5_segments_stds);    
hrv_params.RMSSD = sqrt(mean(dy.^2));

ady = abs(dy);

hrv_params.pNN20 = numel(find(ady > 0.02))/numel(ady);
hrv_params.pNN50 = numel(find(ady > 0.05))/numel(ady);

% Frequency domain HRV measures
[PSD,F] = plomb(y,t);    

iULF = find((F>=0) & (F<0.003));
iVLF = find((F>=0.003) & (F<0.04));
iLF = find((F>=0.04) & (F<0.15));
iHF = find((F>=0.15) & (F<0.4));

hrv_params.aTOTPWR = trapz(PSD(min(iULF):max(iVLF)));
hrv_params.aULF = trapz(PSD(min(iULF):max(iULF)));
hrv_params.aVLF = trapz(PSD(min(iVLF):max(iVLF)));
hrv_params.aLF = trapz(PSD(min(iLF):max(iLF)));
hrv_params.aHF = trapz(PSD(min(iHF):max(iHF)));
hrv_params.rLFHF = hrv_params.aLF/hrv_params.aHF;

end