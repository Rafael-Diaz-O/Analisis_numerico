function [t,y] = my_euler_heun_Rafael_Diaz(fun,a,b,y0,h,mode)
% MY_EULER_HEUN_FIRSTNAME_LASTNAME  Resuelve y' = f(t,y), y(a)=y0 en [a,b]
% con el metodo de Euler o de Heun (una prediccion de Euler y una correccion).
%
%   [t,y] = my_euler_heun_firstname_lastname(fun,a,b,y0,h,mode)
%
%   fun  : handle fun(t,y) que devuelve un escalar real y finito
%   a,b  : tiempo inicial y final (b > a)
%   y0   : valor inicial
%   h    : paso (h > 0), con M = (b-a)/h entero positivo
%   mode : 'euler' o 'heun'
%   t,y  : vectores columna de longitud M+1

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
    error('mode debe ser ''euler'' o ''heun''.');
end
mode = lower(char(mode));
if ~any(strcmp(mode,{'euler','heun'}))
    error('mode debe ser ''euler'' o ''heun''.');
end

% ---------- Metodo ----------
t = a + (0:M)'*h;
t(end) = b;                       % evita error de redondeo en el tiempo final
y = zeros(M+1,1);
y(1) = y0;
for k = 1:M
    f1 = fun(t(k),y(k));
    if ~esEscalar(f1), error('fun debe devolver un escalar real y finito.'); end
    if strcmp(mode,'euler')
        y(k+1) = y(k) + h*f1;
    else
        yp = y(k) + h*f1;                 % prediccion de Euler
        f2 = fun(t(k+1),yp);
        if ~esEscalar(f2), error('fun debe devolver un escalar real y finito.'); end
        y(k+1) = y(k) + (h/2)*(f1 + f2);  % correccion (trapecio)
    end
end
end