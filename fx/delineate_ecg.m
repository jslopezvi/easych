function [fiducial_points,last_Rpeak,delineated_ecg]= delineate_ecg(ecg,fs)
%DELINEATE_ECG La funcion segmentar (segECG), realiza una estimacion de los puntos
%fiduciales del ECG.
%   La funcion permite encontrar los siguientes puntos fiduciales: Onda P (inicio y
%   final). Complejo QRS (Inicio Q, Pico R, Final S). Onda T (inicio y final).
%   Las marcas fiduciales calculadas se almacenan en un objeto de tipo struct
%   y contiene el numero de la muestra donde se ubica un punto cualquiera. La
%   funcion de segmentar, contiene tres parametros que son: la señal, la
%   frecuencia de muestreo y el algoritmo a utilizar para estimar el pico R.

if(nargin<5),
    [Rpeaks,delineated_ecg] = hybrid_qrs(ecg,fs);
    last_Rpeak = max(Rpeaks);
end

% REVIEW If indicador is 1, start on 2.
Rpeaks = Rpeaks(1:length(Rpeaks)-1);

ecg = ecg-mean(ecg);
ecg = ecg/abs(max(ecg));
c1 = cwt(ecg,[2 4 8 16],'gaus1');
signal  = c1(2,:);
signal4 = c1(4,:);
[pqrs , iqrs , fqrs] = dec_qrs2( signal, Rpeaks ,fs);
[ip , fp ] = dec_p(signal4, iqrs , fs );
[it , ft ] = dec_t( ecg , signal4, fqrs , fs );
fiducial_points.Pon = ip;
fiducial_points.Poff = fp;
fiducial_points.Qon = iqrs;
fiducial_points.Rpeak = pqrs;
fiducial_points.Soff = fqrs;
fiducial_points.Ton = it;
fiducial_points.Toff = ft;
