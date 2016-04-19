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

%     datestr(now,'dd-mm-yyyy HH:MM:SS FFF')
    % output2 = freqDomainHRV(myibi,[0 .16],[.16 .6],[.6 3], ...
    %           16,256,128,512,128,{'lomb'},1);

    fs = 128;
    nfft = 512;
    window = 256;
    noverlap = 128;

    t=ibi(:,1); %time (s)
    y=ibi(:,2); %ibi (s)     

%     y=y.*1000; %convert ibi to ms
    %assumes ibi units are seconds

%     maxF=fs/2;
% 
%     %prepare y
%     y=detrend(y,'linear');
%     y=y-mean(y);
% % 
%     deltaF=maxF/nfft;
%     F = linspace(0.0,0.5,nfft);
    F = 0.0:0.0005:0.4;
    [PSD,w] = plomb(y);
    w = w';
%     plot(Psss);
%     PSD=lomb2(y,t,F,false); %calc lomb psd
    
%     plot(F,PSD);
%     plot(t,y);

%     t2 = t(1):1/fs:t(length(t));%time values for interp.
%     y=interp1(t,y,t2','spline')'; %cubic spline interpolation
%     y=y-mean(y); %remove mean
%     
%     %Calculate Welch PSD using hamming windowing    
%     [PSD,F] = pwelch(y,window,noverlap,(nfft*2)-1,fs,'onesided'); 

%     iULF = find((F>=0) & (F<=0.003));
%     iVLF = find((F>=0.003) & (F<=0.04));
%     iLF = find((F>=0.04) & (F<=0.15));
%     iHF = find((F>=0.15) & (F<=0.4));
    
    iULF = find((w>=0) & (w<=0.003));
    iVLF = find((w>=0.003) & (w<=0.04));
    iLF = find((w>=0.04) & (w<=0.15));
    iHF = find((w>=0.15) & (w<=0.4));
    
%     fprintf('ULF count for %s = %d\n',record_name,sum(iULF));
%     fprintf('VLF count for %s = %d\n',record_name,sum(iVLF));
%     fprintf('LF count for %s = %d\n',record_name,sum(iLF));
%     fprintf('HF count for %s = %d\n',record_name,sum(iHF));
%     fprintf('\n');

    % output.lomb.hrv = calcAreas(output.lomb.f,output.lomb.psd,VLF,LF,HF,true);
%     areaso = compute_psd_areas(F,PSD,[0 0.003], [0.003 0.04], [0.04 0.15], [0.15 0.4], false);
    
%     aULF = trapz(F(min(iULF):max(iULF)), PSD(min(iULF):max(iULF)));
%     aVLF = trapz(F(min(iVLF):max(iVLF)), PSD(min(iVLF):max(iVLF)));
%     aLF = trapz(F(min(iLF):max(iLF)), PSD(min(iLF):max(iLF)));
%     aHF = trapz(F(min(iHF):max(iHF)), PSD(min(iHF):max(iHF)));
    
    aT = trapz(PSD(min(iULF):max(iHF)));
    aULF = trapz(PSD(min(iULF):max(iULF)));
    aVLF = trapz(PSD(min(iVLF):max(iVLF)));
    aLF = trapz(PSD(min(iLF):max(iLF)));
    aHF = trapz(PSD(min(iHF):max(iHF)));
    
    fprintf('aT for %s = %f\n',record_name,aT);
    fprintf('aULF for %s = %f\n',record_name,aULF);
    fprintf('aVLF for %s = %f\n',record_name,aVLF);
    fprintf('aLF for %s = %f\n',record_name,aLF);
    fprintf('aHF for %s = %f\n',record_name,aHF);
    fprintf('aLRHF for %s = %f\n',record_name,aLF/aHF);
    fprintf('\n');
    
%     fprintf('aULF for %s = %f, %f%%\n',record_name,areaso.aULF,areaso.pULF);
%     fprintf('aVLF for %s = %f, %f%%\n',record_name,areaso.aVLF,areaso.pVLF);
%     fprintf('aLF for %s = %f, %f%%\n',record_name,areaso.aLF,areaso.pLF);
%     fprintf('aHF for %s = %f, %f%%\n',record_name,areaso.aHF,areaso.pHF);
%     fprintf('\n');
    
%     plot(F,PSD);
%     pause();

%     datestr(now,'dd-mm-yyyy HH:MM:SS FFF')
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
