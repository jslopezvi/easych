function Fcardiaca = estimate_heart_rate(picosR,ECG,Fs)
% FreCard Estimacion de frecuencia cardiaca.
%   Realiza una estimacion de la frecuencia cardiaca promedio.
nRR = numel(picosR);
RR = zeros(1,nRR-1);
N  = length (ECG);       % Signal length
t  = (0:N-1)/Fs;

% Medir las distancias entre picosR adyacentes para todo el
% registro.
for i = 1:nRR-1,
    RR(1,i) = t(picosR(1,i+1)) - t(picosR(1,i));   
end

% La frecuencia cardiaca corresponde a el numero de segundos de un
% minuto dividos la distancia entre picos R promedio (la duracion
% promedio de un latido).
Fcardiaca = floor(60/(mean(RR)));

end