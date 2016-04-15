% Simulates an ECG device by sending to serial port ECG signals from
% synthetic database or real databases such us MIT-BIH.
% The simulation is possible thanks to VSPE sofware (in Microsoft Windows),
% which creates a pair of virtual serial ports. This simulator writes data
% to COM2 (by default) and EasyCH reads data on COM3 serial port. Default
% baudrate for transfer is 115200 which has an approximate maximum transfer
% of 11520 bytes per second. If we send double values, 4 bytes each one,
% then we can send 2880 values per second, which means an approximate
% max sampling frequency of 2880 Hz, which is pretty high for ECG
% applications. A 250 Hz or 360 Hz sampling frequency should be enough.

% Read signal from database.

% Open connection with serial port COM2

% Through all signal duration, send data. At the end, just send zeros or
% small noise.