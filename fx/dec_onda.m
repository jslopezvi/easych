function [pico , inicio, final] = dec_onda(posMax,posMin,ventana,param)

%%%si el parametro es 0, posMax esta a la derecha de posMin

%%%si el parametro es 1, posMax esta a la izquierda de posMin

%%%%%%%%%%%%%%%%%%%%%%%%SI EL MODULO ES MINIMO - MAXIMO 
if param == 0
 %%%%%%%%Para detectar el pico  
   k = posMin;
   minim = ventana(k);
   while minim < 0
       k = k + 1;
       if k < length(ventana)
          minim = ventana(k);
       else
          k = posMin;
          break;
      end
   end
   pico = k-1; % TO REVIEW: Porque se resta 1? Porque k se aumento 1 antes del break.
 %%%%%%%Para detectar el inicio 
   k = posMin;
   minim = ventana(k);
   umbral = minim*0.1;    %se toma el 10% del valor del pico minimo
   while minim < umbral
       k = k - 1;
       if k > 1
          minim = ventana(k);
       else
          k = posMin;
          break;
        end
   end
   inicio = k-3; % TO REVIEW: Porque se resta 3?
  %%%%%%%Para detectar el final
   k = posMax;
   maxim = ventana(k);
   umbral = maxim*0.1;
   while maxim > umbral
       k = k + 1;
       if k < length(ventana)
          maxim = ventana(k);
       else
          k = posMax;
          break;
       end
   end
   final = k;   

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SI EL MODULO ES  MAXIMO - MINIMO %%%%%%
else
   k = posMax;
   maxim = ventana(k);
   while maxim > 0
       k = k+1;
       if k < length(ventana)
          maxim = ventana(k);
      else
          k = posMax;
          break;
      end
   end
   pico = k;
   
   %%%%%%%Para detectar el inicio 
   k = posMax;
   maxim = ventana(k);
   umbral = maxim*0.1;    %se toma el 10% del valor del pico minimo
   while maxim > umbral
       k = k - 1;
       if k > 1
          maxim = ventana(k);
       else
          k = posMax;
          break;
        end
   end
   inicio = k-2;
  %%%%%%%Para detectar el final 
   k = posMin;
   minim = ventana(k);
   umbral = minim*0.1;
   while minim < umbral
       k = k + 1;
       if k < length(ventana)
          minim = ventana(k);
       else
          k = posMin;
          break;
       end
   end
   final = k;   

   
   
   
   
   
end