function ecg_device_stop_callback(timerHandle,~)
%ECG_DEVICE_STOP_CALLBACK Summary of this function goes here
%   Detailed explanation goes here

% Read timer_data struct
timer_data = timerHandle.UserData;

% Use timer_data fields
fprintf('Current byte = %d, Signal length = %d\n', timer_data.current_byte, numel(timer_data.signal));
fprintf('Timer stopped, all bytes written!\n');

% Close serial port
if(isvalid(timer_data.serial_port_handle) && strcmp(timer_data.serial_port_handle.Status,'open') == 1),
    fclose(timer_data.serial_port_handle);
    delete(timer_data.serial_port_handle);
end
end

