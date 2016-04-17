function m = medfilt1D(s, w)
%medfilt1D Filtro de mediana
%   Implementacion de filtro de mediana con ventana de tamano w.
    if nargin == 1,
        w = 5;
    end

    s = s(:)';
    w2 = floor(w/2);
    w = 2*w2 + 1;

    n = length(s);
    m = zeros(w,n+w-1);
    s0 = s(1); sl = s(n);

    for i=0:(w-1),
        m(i+1,:) = [s0*ones(1,i) s sl*ones(1,w-i-1)];
    end
    
    m = median(m);
    m = m(w2+1:w2+n);
end