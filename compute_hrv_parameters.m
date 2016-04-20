clc;

% Compute HRV parameters
% nsrdb_struct = load('db/nsr2db.mat');
% nsrdb = nsrdb_struct.nsr2db;
nsrdb_struct = load('db/nsrdb.mat');
nsrdb = nsrdb_struct.nsrdb;

nsrdb_fields = fieldnames(nsrdb);
for i=1:numel(nsrdb_fields),
    record_name = nsrdb_fields{i};    
    data = nsrdb.(record_name);
    fs = 128;

    inter = diff(data);
    times = inter/fs;
    ibi = zeros(numel(times), 2);

    ibi(1,1) = 0;
    ibi(:,2) = times;

    for j=1:numel(times)-1,
        ibi(j+1,1) = ibi(j,2) + ibi(j,1);
    end           

    t = ibi(:,1); %time (s)
    y = ibi(:,2); %ibi (s)     
    dy = diff(y);
    
    % Time domain HRV measures        
    AVNN = mean(y);
    SDNN = std(y);
    
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
    
    SDANN = std(m5_segments_means);
    SDNNIDX = mean(m5_segments_stds);    
    rMSSD = sqrt(mean(dy.^2));
     
    ady = abs(dy);
    
    pNN20 = numel(find(ady > 0.02))/numel(ady);
    pNN50 = numel(find(ady > 0.05))/numel(ady);
    
    fprintf('AVNN for %s = %f\n',record_name,AVNN);
    fprintf('SDNN for %s = %f\n',record_name,SDNN);
    fprintf('SDANN for %s = %f\n',record_name,SDANN);
    fprintf('SDNNIDX for %s = %f\n',record_name,SDNNIDX);
    fprintf('rMSSD for %s = %f\n',record_name,rMSSD);
    fprintf('pNN20 for %s = %f\n',record_name,pNN20);
    fprintf('pNN50 for %s = %f\n',record_name,pNN50);
    
    % Frequency domain HRV measures
    [PSD,F] = plomb(y,t);    
    
    iULF = find((F>=0) & (F<0.003));
    iVLF = find((F>=0.003) & (F<0.04));
    iLF = find((F>=0.04) & (F<0.15));
    iHF = find((F>=0.15) & (F<0.4));
    
    aT = trapz(PSD(min(iULF):max(iVLF)));
    aULF = trapz(PSD(min(iULF):max(iULF)));
    aVLF = trapz(PSD(min(iVLF):max(iVLF)));
    aLF = trapz(PSD(min(iLF):max(iLF)));
    aHF = trapz(PSD(min(iHF):max(iHF)));
    
%     aT = trapz(F(min(iULF):max(iVLF)), PSD(min(iULF):max(iVLF)));
%     aULF = trapz(F(min(iULF):max(iULF)), PSD(min(iULF):max(iULF)));
%     aVLF = trapz(F(min(iVLF):max(iVLF)), PSD(min(iVLF):max(iVLF)));
%     aLF = trapz(F(min(iLF):max(iLF)), PSD(min(iLF):max(iLF)));
%     aHF = trapz(F(min(iHF):max(iHF)), PSD(min(iHF):max(iHF)));
    
    fprintf('aT for %s = %f\n',record_name,aT);
    fprintf('aULF for %s = %f\n',record_name,aULF);
    fprintf('aVLF for %s = %f\n',record_name,aVLF);
    fprintf('aLF for %s = %f\n',record_name,aLF);
    fprintf('aHF for %s = %f\n',record_name,aHF);
    fprintf('aLRHF for %s = %f\n',record_name,aLF/aHF);
    fprintf('\n');
end

% record_name = 'nsrdb/rec16265.mat';
% data_struct = load('nsrdb/rec16265.mat');
% data = data_struct.data;
% fs = 128;
% 
% inter = diff(data);
% 
% times = inter/fs;
% 
% ibi = zeros(numel(times), 2);
% 
% ibi(1,1) = 0;
% ibi(:,2) = times;
% 
% for i=1:numel(times)-1,
%     ibi(i+1,1) = ibi(i,2) + ibi(i,1);
% end
% 
% save('test_ibi.mat','ibi');
