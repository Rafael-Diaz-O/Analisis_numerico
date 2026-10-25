function [t,y] = my_taylor_rk4_Rafael_Diaz(fun,derivs,a,b,y0,h,mode)
% MY_TAYLOR_RK4_FIRSTNAME_LASTNAME  Resuelve y' = f(t,y), y(a)=y0 en [a,b]
% con Taylor de orden 4 o Runge-Kutta clasico de cuatro etapas.
%
%   [t,y] = my_taylor_rk4_firstname_lastname(fun,derivs,a,b,y0,h,mode)
%
%   fun    : handle fun(t,y) -> y'
%   derivs : handle derivs(t,y) -> vector [y'', y''', y''''] (solo 'taylor4');
%            para 'rk4' se pasa []
%   mode   : 'taylor4' o 'rk4'

% ---------- Validacion de entradas ----------
if ~isa(fun,'function_handle')
    error('fun debe ser un function handle.');
end
esEscalar = @(x) isnumeric(x) && isscalar(x) && isreal(x) && isfinite(x);
if ~(esEscalar(a) && esEscalar(b) && esEscalar(y0) && esEscalar(h))
    error('a, b, y0 y h deben ser escalares reales y finitos.');
end
if ~(b > a),  error('Se requiere b > a.');  end
if ~(h > 0),  error('Se requiere h > 0.'); end
M = (b - a)/h;
if abs(M - round(M)) > 1e-9*max(1,abs(M)) || round(M) < 1
    error('(b-a)/h debe ser un entero positivo.');
end
M = round(M);
if ~(ischar(mode) || isstring(mode))
    error('mode debe ser ''taylor4'' o ''rk4''.');
end
mode = lower(char(mode));
if ~any(strcmp(mode,{'taylor4','rk4'}))
    error('mode debe ser ''taylor4'' o ''rk4''.');
end
if strcmp(mode,'taylor4') && ~isa(derivs,'function_handle')
    error('Para ''taylor4'' derivs debe ser un function handle.');
end

% ---------- Metodo ----------
t = a + (0:M)'*h;
t(end) = b;
y = zeros(M+1,1);
y(1) = y0;
for k = 1:M
    tk = t(k);  yk = y(k);
    if strcmp(mode,'taylor4')
        d  = derivs(tk,yk);
        if numel(d) ~= 3 || ~all(isreal(d(:))) || ~all(isfinite(d(:)))
            error('derivs debe devolver un vector real y finito de 3 entradas.');
        end
        d  = d(:);
        y1 = fun(tk,yk);
        y(k+1) = yk + h*y1 + h^2/2*d(1) + h^3/6*d(2) + h^4/24*d(3);
    else
        k1 = fun(tk,        yk);
        k2 = fun(tk + h/2,  yk + h/2*k1);
        k3 = fun(tk + h/2,  yk + h/2*k2);
        k4 = fun(tk + h,    yk + h*k3);
        y(k+1) = yk + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
    end
    if ~isfinite(y(k+1)), error('La solucion numerica dejo de ser finita.'); end
end
end