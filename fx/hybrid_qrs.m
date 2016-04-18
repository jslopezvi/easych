function [ picoR, senalResul ] = hybrid_qrs( senal, fs )
%%%%%%%%HELP%%%%%%%%%%%%
% Algoritmo que realiza estimacion de marca fiducial
% del pico R, utilizando:
% filtro pasabanda
% filtro spline
% energia de shannon
% normalizacion de shannon
% interpolacion
% umbralizacion adaptativa en amplitud y tiempo
% periodo refractario
% %
% La funcion tiene dos parametros que son:
% la señal y la frecuencia de muestreo.
%     
%        PICOS = QRS_HIBRIDO(SENAL,FS)
%
%tomado de JOSE LUIS RODRIGUEZ 2004 (MASTER THESIS)
%revisado por JL RODRIGUEZ S 2006
%%%%%%%%%%%%%%%%%%%%%%%

ecg = senal;
picoR = 1;  %inicializar el valor de los picosR
%%%%%%%%%%%%%%%%%%%%%%
%begin preproceso
%ETAPA PARA PREPROCESAR LA SEÑAL, es decir, quitarle el nivel DC
%y normalizarla 
ecg = ecg - mean(ecg); %quitar nivel DC de la señal
ecg = ecg/max(abs(ecg)); %normalizar la señal
%end preproceso
%%%%%%%%%%%%%%%%%%%%%
%begin algoritmo
senal = ecg;

%%%%coeficientes para filtro pasabajo con corte en 15 Hz
%%%%%tomado de Tomkins
aPB=[1 -2 1 zeros(1,10)];
bPB=[1 zeros(1,5) -2  zeros(1,5) 1];
%%%%coeficientes para filtro pasa alto con corte en 5 Hz
%%%%%tomado de Tomkins
aPA=[1 -1 zeros(1,31)];
bPA=[-1/32 zeros(1,15) 1 -1 zeros(1,14) 1/32];
%%%se filtra la señal para aplicarle el filtro pasabanda total de 5 - 15 Hz
senalPB = filter(bPB,aPB,senal);
senalResul = filter(bPA,aPA,senalPB);
%%%% se normalizan las señales
senalResul = senalResul/max(senalResul);
q_1w = [2 -2];
SenalR = filter(q_1w,[1],senalResul); % escala 2^1 para la SPLINE
SenalResulSpline1 = SenalR; 
%esta parte es para aproximar las muestras que son 0 de la señal ECG filtrada a un valor diferente
%para evitar la discontinuidad por el logaritmo de 0, en la energia de
%Shannon
N = floor(0.08*fs);  %%%se toma una ventana de 80ms para la energia de shannon.

SenalResulSpline1(find(SenalResulSpline1==0)) = 0.000001;
Es(1:round(length(SenalResulSpline1)/N)) =0;
k=1;
for i=1:N/2:length(SenalResulSpline1)-N
    Es(k) = (-1/N).*sum(((SenalResulSpline1(i:i+N)).^2).*(log((SenalResulSpline1(i:i+N)).^2))); 
    k=k+1;
   %se calcula la energía de la envolvente de shanon con ventanas de
   %80mseg traslapadas con 40mseg. La ventana corresponde a la duracion de
   %un complejo QRS aprox. para unir los picos de energia del filtro
   %spline.
end
%%se normaliza por medio de la energia de shannon con la media y desviacion
%%estandar.
Es_P = ( Es - mean(Es) )/ std(Es);   

%Es_int=interp(Es_P,N/2);
Es_int = InterLineal(Es_P,N/2);

Es_int = Es_int/max(Es_int);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INICIO DE BUSQUEDA DE PICO R
%%% se realiza un busqueda en las 500 primeras muestras del maximo para
%%% determinar el valor del umbral (aprox. 2 o 3 latidos)
% Aj = max(Es_int(1:500));
Aj = max(Es_int);
umbral = 0.35*Aj;
%%% se inicia un recorrido de la energia para encontrar los picos R.
k = 1;
i = floor(0.04*fs);
bandera_sb= 0;
picoR=0;
while i < length(Es_int) - 1
    if bandera_sb == 1
       umbral= umbral/2;    
       while i < picoRultimo-(0.8*fs)
           if Es_int(i) > umbral
              [valor,pos]= max(Es_int(i:i+(0.4*fs)));
              picoR(k)= pos + i;
              k=k+1;
              i= i+(0.4*fs);
          else
              i= i+1;
          end
       end
       umbral= umbral*2;
       i= picoRultimo+(0.4*fs);
       bandera_sb= 0;
       picoR(k)=picoRultimo;
       k=k+1;
    end
    if i > length(Es_int)
        break
    end
    if Es_int(i) > umbral
       [valor,pos]= max(Es_int(i:i+1));
       picoR(k)= pos + i;
      %i=i+200; %se toman 200 muestras desde el inicio del pico encontrado, es decir que el periodo refractario  
                %encuentra entre 100 -120 muestras que corresponde a
                %200mseg - 250mseg.
       if valor < 2*Aj  %se presenta un umbral adaptativo para evitar los picos sobresalientes con respecto a 
                        %picos pequeños debido a la baja amplitud de picos
                        %R, con la siguiente relacion.
           Aj= (7/8)*Aj + (1/8)*valor;
           umbral= 0.35*Aj;
       end
    % se aumenta contador para el numero de complejos QRS.
    %en esta parte se realiza una busqueda hacia atras colocando el umbral
    %a la mitad en caso de que se hayan perdido complejos QRS. El intervalo
    %de perdida es cuando se sobrepase el umbral RRAV2
        if k>=2
           RRact= picoR(k)-picoR(k-1);
        else
           RRact = floor(fs*0.8);
        end
   
        if k == 1
           RRAV1_v = [floor(fs*0.8)*ones(1,8)];
        end
        for j = 2:8
           RRAV1_v(j-1)= RRAV1_v(j);
        end
        RRAV1_v(8)= RRact;
        RRAV1= sum(RRAV1_v)/8;
              
       
       if RRact < 1.16*RRAV1 & RRact > 0.92*RRAV1 
          if k == 1
             RRnorm = [floor(fs*0.8)*ones(1,8)];
          end
          for j = 2:8
             RRnorm(j-1)= RRnorm(j);
          end
          RRnorm(8)= RRact;
          RRAV2 = sum(RRnorm)/8;   
       end     
           
       if k >= 2
          if RRact > RRAV2*1.66
             bandera_sb =1;
             i= picoR(k-1) + round(0.6*fs);
             picoRultimo= picoR(k);
         else
             k= k+1;  
             i= i+ round(0.2*fs);
         end
       else
            k= k+1;
            i= i+ round(0.2*fs);
       end
   else
       i= i+1;
   end
end
%end algoritmo
%%%%%%%%%%%%%%%%%%%
%picoR = picoR - 11;