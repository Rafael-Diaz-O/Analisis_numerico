clc; clear; close all;

%% EJERCICIO 1: Diferenciación numérica
% f(x) = e^x * sin(2x), derivada en x = 1

f      = @(x) exp(x).*sin(2*x);
x0     = 1;
exacto = exp(1)*(sin(2) + 2*cos(2));      % f'(1) exacta

denom  = [2 4 6 8 10 12 14 16 18 20];
hs     = 1./denom;
nh     = numel(hs);

adelante = zeros(nh,1);
atras    = zeros(nh,1);
central  = zeros(nh,1);

for k = 1:nh
    adelante(k) = my_derivative_Rafael_Diaz(f, x0, hs(k), 'forward');
    atras(k)    = my_derivative_Rafael_Diaz(f, x0, hs(k), 'backward');
    central(k)  = my_derivative_Rafael_Diaz(f, x0, hs(k), 'central');
end

err_adelante = abs(adelante - exacto);
err_atras    = abs(atras    - exacto);
err_central  = abs(central  - exacto);

%% Tabla de resultados
fprintf('Valor exacto f''(1) = %.12f\n\n', exacto);
fprintf('%-8s %-16s %-16s %-16s %-14s %-14s %-14s\n', ...
    'h', 'Adelante', 'Atras', 'Central', 'Err Adelante', 'Err Atras', 'Err Central');
fprintf('%s\n', repmat('-', 1, 106));
for k = 1:nh
    fprintf('1/%-6d %-16.10f %-16.10f %-16.10f %-14.4e %-14.4e %-14.4e\n', ...
        denom(k), adelante(k), atras(k), central(k), ...
        err_adelante(k), err_atras(k), err_central(k));
end

%% Gráfica de errores (ejes logarítmicos)
figure;
loglog(hs, err_adelante, '-o', 'LineWidth', 1.5); hold on;
loglog(hs, err_atras,    '-s', 'LineWidth', 1.5);
loglog(hs, err_central,  '-^', 'LineWidth', 1.5);
grid on;
xlabel('Tamaño de paso h');
ylabel('Error absoluto');
title('Error absoluto de la derivada numérica de f(x) = e^x sin(2x) en x = 1');
legend('Adelante (forward)', 'Atrás (backward)', 'Central (central)', ...
    'Location', 'southeast');
hold off;

%% ====================== FUNCIONES LOCALES ======================

function D = my_derivative_Rafael_Diaz(fun, x, h, mode)
% Aproxima la primera derivada f'(x) con fórmulas de orden O(h^2).
%   fun  : handle de la función f
%   x    : punto donde se evalúa la derivada (escalar real finito)
%   h    : tamaño de paso positivo (escalar real finito)
%   mode : 'forward', 'backward' o 'central'

    % ---- Validación de entradas ----
    if ~isa(fun, 'function_handle')
        error('fun debe ser un function handle.');
    end
    if ~(isscalar(x) && isnumeric(x) && isreal(x) && isfinite(x))
        error('x debe ser un escalar real y finito.');
    end
    if ~(isscalar(h) && isnumeric(h) && isreal(h) && isfinite(h) && h > 0)
        error('h debe ser un escalar real, finito y positivo.');
    end
    if ~((ischar(mode) && isrow(mode)) || (isstring(mode) && isscalar(mode)))
        error('mode debe ser una cadena de texto.');
    end
    mode = char(mode);

    % ---- Puntos y fórmula según el modo ----
    switch lower(mode)
        case 'forward'      % (-3f(x) + 4f(x+h) - f(x+2h)) / (2h)
            pts = [x, x+h, x+2*h];
            fv  = evaluar(fun, pts);
            D   = (-3*fv(1) + 4*fv(2) - fv(3)) / (2*h);
        case 'backward'     % (3f(x) - 4f(x-h) + f(x-2h)) / (2h)
            pts = [x, x-h, x-2*h];
            fv  = evaluar(fun, pts);
            D   = (3*fv(1) - 4*fv(2) + fv(3)) / (2*h);
        case 'central'      % (f(x+h) - f(x-h)) / (2h)
            pts = [x+h, x-h];
            fv  = evaluar(fun, pts);
            D   = (fv(1) - fv(2)) / (2*h);
        otherwise
            error('Modo no valido. Use ''forward'', ''backward'' o ''central''.');
    end
end

function fv = evaluar(fun, pts)
% Evalúa fun en cada punto y verifica que los valores sean reales y finitos.
    fv = zeros(1, numel(pts));
    for i = 1:numel(pts)
        v = fun(pts(i));
        if ~(isscalar(v) && isnumeric(v) && isreal(v) && isfinite(v))
            error('fun debe devolver valores escalares reales y finitos en todos los puntos usados.');
        end
        fv(i) = v;
    end
end