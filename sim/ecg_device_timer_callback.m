function ecg_device_timer_callback(timerHandle,~)
%TIMER_CALLBACK Sends a samples_per_second bytes each tenth of second.
%   Each tenth of second (0.1 seg) write bytes to serial port.

% Read timer_data struct
timer_data = timerHandle.UserData;

% Use timer_data fields

% Compute end index for writing.
end_index = timer_data.current_byte + timer_data.samples_per_tenth_second;

% By default suppose that end hasn't been reached.
timer_data.finished = 0; 

% Check end of signal.
if(end_index > numel(timer_data.signal)),
    end_index = numel(timer_data.signal);
    timer_data.finished = 1;
end

for i=timer_data.current_byte:end_index,
    % Bytes are sent LittleEndian (Most Significant Byte first).
    value = timer_data.signal(i);

    b1 = bitand(bitshift(value,-8*3),255); % Most significant byte
    b2 = bitand(bitshift(value,-8*2),255);
    b3 = bitand(bitshift(value,-8*1),255);
    b4 = bitand(bitshift(value,-8*0),255); % Less significant byte

    bytes = [b1 b2 b3 b4];

    % Write bytes to serial port.
    if(isvalid(timer_data.serial_port_handle) && strcmp(timer_data.serial_port_handle.Status,'open') == 1),
        fwrite(timer_data.serial_port_handle, bytes);
    else 
        fprintf('Warning: sending bytes to closed or invalid serial port!\n');
    end
end

% Save current_index
timer_data.current_byte = timer_data.current_byte + (end_index - timer_data.current_byte) + 1;

fprintf('Writing progress = %03.2f%%\n',100*timer_data.current_byte/numel(timer_data.signal));

% Save timer_data struct
timerHandle.UserData = timer_data;

% Stop timer if 
if(timer_data.finished == 1),
    stop(timerHandle);
end

end

