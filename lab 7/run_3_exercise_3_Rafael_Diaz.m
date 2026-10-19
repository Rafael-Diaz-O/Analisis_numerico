clc; clear; close all;

%% EJERCICIO 3: Aplicación - distancia recorrida
% p(t) = 10 sin(t/2) m,  0 <= t <= 12 s,  t_i = 0.5 i, i = 0..24

p = @(t) 10*sin(t/2);
h = 0.5;
t = (0:24)*h;
n = numel(t);

%% ---------- Parte (a): velocidad v(t) = p'(t) ----------
v = zeros(1, n);
for i = 1:n
    if i == 1
        modo = 'forward';        % t = 0
    elseif i == n
        modo = 'backward';       % t = 12
    else
        modo = 'central';        % resto de tiempos
    end
    v(i) = my_derivative_Rafael_Diaz(p, t(i), h, modo);
end

fprintf('PARTE (a): Velocidad estimada\n');
fprintf('%-10s %-18s\n', 'Tiempo (s)', 'Velocidad (m/s)');
fprintf('%s\n', repmat('-', 1, 30));
for i = 1:n
    fprintf('%-10.1f %-18.8f\n', t(i), v(i));
end

figure;
plot(t, v, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'auto');
grid on;
xlabel('Tiempo t (s)');
ylabel('Velocidad estimada v(t) (m/s)');
title('Velocidad estimada del vehículo');
legend('v(t) estimada (muestras)', 'Location', 'best');

%% ---------- Parte (b): distancia total d = integral |v(t)| dt ----------
absv = abs(v);

reglas  = {'trapezoidal', 'simpson13', 'simpson38', 'boole'};
nombres = {'Trapecio', 'Simpson 1/3', 'Simpson 3/8', 'Boole'};

fprintf('\nPARTE (b): Distancia total recorrida\n');
fprintf('%-14s %-20s\n', 'Regla', 'Distancia (m)');
fprintf('%s\n', repmat('-', 1, 36));
for r = 1:4
    d = my_integral_Rafael_Diaz(t, absv, reglas{r});
    fprintf('%-14s %-20.8f\n', nombres{r}, d);
end

%% ====================== FUNCIONES LOCALES ======================

function D = my_derivative_Rafael_Diaz(fun, x, h, mode)
% Aproxima la primera derivada f'(x) con fórmulas de orden O(h^2).

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

    switch lower(mode)
        case 'forward'
            pts = [x, x+h, x+2*h];
            fv  = evaluar(fun, pts);
            D   = (-3*fv(1) + 4*fv(2) - fv(3)) / (2*h);
        case 'backward'
            pts = [x, x-h, x-2*h];
            fv  = evaluar(fun, pts);
            D   = (3*fv(1) - 4*fv(2) + fv(3)) / (2*h);
        case 'central'
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

function Q = my_integral_Rafael_Diaz(x, y, mode)
% Estima la integral desde el primer hasta el último punto de una tabla
% (x, y) con puntos igualmente espaciados, usando reglas compuestas.

    if ~(isnumeric(x) && isnumeric(y) && isvector(x) && isvector(y))
        error('x e y deben ser vectores numericos.');
    end
    if ~(isreal(x) && isreal(y) && all(isfinite(x)) && all(isfinite(y)))
        error('x e y deben ser reales y finitos.');
    end
    if numel(x) ~= numel(y)
        error('x e y deben tener la misma longitud.');
    end
    if numel(x) < 2
        error('Se requieren al menos 2 puntos.');
    end
    if ~((ischar(mode) && isrow(mode)) || (isstring(mode) && isscalar(mode)))
        error('mode debe ser una cadena de texto.');
    end
    mode = char(mode);

    x = x(:); y = y(:);
    dx = diff(x);                      % solo para validar el espaciado
    if any(dx <= 0)
        error('Los puntos de x deben ser estrictamente crecientes.');
    end
    h = (x(end) - x(1)) / (numel(x) - 1);
    if any(abs(dx - h) > 1e-8*max(1, abs(h)))
        error('Los puntos de x deben estar igualmente espaciados.');
    end

    N = numel(x) - 1;
    i = (0:N).';

    switch lower(mode)
        case 'trapezoidal'
            w = 2*ones(N+1,1);
            w([1 end]) = 1;
            Q = (h/2) * sum(w .* y);

        case 'simpson13'
            if mod(N,2) ~= 0
                error('Simpson 1/3 requiere N multiplo positivo de 2.');
            end
            w = zeros(N+1,1);
            w(mod(i,2) == 1) = 4;
            w(mod(i,2) == 0) = 2;
            w([1 end]) = 1;
            Q = (h/3) * sum(w .* y);

        case 'simpson38'
            if mod(N,3) ~= 0
                error('Simpson 3/8 requiere N multiplo positivo de 3.');
            end
            w = 3*ones(N+1,1);
            w(mod(i,3) == 0) = 2;
            w([1 end]) = 1;
            Q = (3*h/8) * sum(w .* y);

        case 'boole'
            if mod(N,4) ~= 0
                error('Boole requiere N multiplo positivo de 4.');
            end
            w = zeros(N+1,1);
            w(mod(i,2) == 1) = 32;
            w(mod(i,4) == 2) = 12;
            w(mod(i,4) == 0) = 14;
            w([1 end]) = 7;
            Q = (2*h/45) * sum(w .* y);

        otherwise
            error('Modo no valido. Use ''trapezoidal'', ''simpson13'', ''simpson38'' o ''boole''.');
    end
end