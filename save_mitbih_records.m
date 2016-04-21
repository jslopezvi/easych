addpath('sim');
load('db/MITDB.mat');

record_names = fieldnames(MITDB);

for i=1:numel(record_names),
    [data, fs] = load_mitbih_arrhythmia_record(record_names{i},360);
    save(strcat('db/ecg_recs/mitbih/',record_names{i},'.mat'), 'data');
    fprintf('Saved record %s\n',record_names{i});
end
