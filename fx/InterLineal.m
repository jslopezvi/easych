function z = InterLineal(x,k)
% InterLineal Realiza interpolacion lineal entre los puntos x
% suministrados.
%   Entre cada punto del vector x debe haber k-1 puntos. La interpolacion
%   se realiza calculando el valor de la pendiente entre puntos adyacentes
%   de x.

z = [];

for i=1:length(x)-1,
    m = (x(i+1)-x(i))/k;
    y = zeros(1,k-1);
    for j=1:k-1
        y(1,j)=x(i)+j*m;
    end
    z = horzcat(z,x(i),y);
end

z = horzcat(z,x(length(x)));

end