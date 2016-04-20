% Simulates an ECG device by sending to serial port ECG signals from
% synthetic database or real databases such us MIT-BIH.
clc;
addpath('sim');
serial_port_com = 'COM2';
serial_port_baudrate = 115200;

% The simulation is possible thanks to VSPE sofware (in Microsoft Windows),
% downloadable from http://www.eterlogic.com/downloads/SetupVSPE.zip,
% which creates a pair of virtual serial ports. This simulator writes data
% to COM2 (by default) and EasyCH reads data on COM1 serial port. Default
% baudrate for transfer is 115200 which has an approximate maximum transfer
% of 11520 bytes per second. If we send int values, 4 bytes each one,
% then we can send 2880 values per second, which means an approximate
% max sampling frequency of 2880 Hz, which is pretty high for ECG
% applications. A 250 Hz or 360 Hz sampling frequency should be enough.

% Read signal from database. With desired
[signal, fs] = load_mitbih_arrhythmia_record('rec103',360);

% Open connection with serial port COM2 with a baudrate of 115200
s = serial(serial_port_com,'BaudRate',serial_port_baudrate,'DataBits',8);
s.OutputBufferSize = 50000;

try
    fopen(s);
catch ME
    fprintf('Error opening serial port %s: %s\n', serial_port_com, ME.message);
    return;
end

% Read number of points of signal
n = numel(signal);

% If there are any bytes, send them.
if(n > 0),
    sim_timer = timer;
    sim_timer.StartDelay = 0;
    sim_timer.Period = 10/fs;
    sim_timer.ExecutionMode = 'fixedRate';
    sim_timer.TimerFcn = @ecg_device_timer_callback;
    sim_timer.StopFcn = @ecg_device_stop_callback;
    
    timer_data.current_byte = 1;
    timer_data.samples_per_tenth_second = fs/10;
    timer_data.finished = 0;
    timer_data.signal = signal;
    timer_data.serial_port_handle = s;
    
    sim_timer.UserData = timer_data;
        
    % Start simulation timer.
    start(sim_timer);
    disp('Timer started...');
end

% Through all signal duration, send data. At the end, just send zeros or
% small noise.